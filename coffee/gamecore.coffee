import { Animation } from './animation'
import { EventEmmiter } from './events'
import { GameControl } from './gamecontrol'
import { LoadStage } from './stages/loadstage'
import { MainMenuStage } from './stages/menustage'
import { Locale } from './locale'
# import { Engine } from './engine'
import { Loader } from './loader'


countFPS = do ->
	lastLoop = (new Date).getMilliseconds()
	count = 1
	fps = 0
	->
		currentLoop = (new Date).getMilliseconds()
		if lastLoop > currentLoop
			fps = count
			count = 1
		else
			count += 1
		lastLoop = currentLoop
		fps

infoFps = $ '.js-fps'

class GameCore extends EventEmmiter

	cameraZoom: 0
	pauseTime: 0
	pause: false
	delta: 0

	constructor: (@canvas, @context, @mode = 'easy') ->
		super()
		@loader = new Loader
		@gamestages = $ '.gamestage'
		@loadStage = new LoadStage this
		@stages =
			mainmenu: new MainMenuStage this
		@time = Animation.getTime()
		@delta = 0
		@fill = '#000'

	load: ->
		@setLocale 'ru'
		@loadStage.setStage 'mainmenu'
		this

	setLocale: (locale) ->
		@loader.loadJson "locales/locale_#{locale}", (data) ->
			Locale.add data
			$('[data-text]').each ->
				_this = $ this
				_this.text Locale.text _this.data 'text'

	setStage: (stage) ->
		stage = @stages[stage] if typeof stage == 'string'
		@gamestages.addClass 'hidden'
		@stage?.unset?()
		if stage
			$(".gamestage.#{stage.name}").removeClass 'hidden' if stage.name
			stage.set?()
		@stage = stage
		this

	render: ->
		rndr = (delta) =>
			@context.save()

			@stage?.update? @time, @delta

			w = @canvas.width
			h = @canvas.height
			@context.fillStyle = @fill
			@context.fillRect 0, 0, w, h
			@context.translate w / 2, h / 2

			@stage?.draw?()

			unless @pause
				time = Animation.getTime() - @pauseTime
				@delta = time - @time
				@time = time

			@context.restore()

			infoFps.text countFPS()
			# 
			window.requestAnimationFrame rndr
		rndr 0
		this

	pause: ->
		# @engine.pause()
		@pause = true
		@delta = 0

	unpause: ->
		if @pause
			# @engine.unpause()
			@pause = false
			@pauseTime += Animation.getTime() - @time

export { GameCore }