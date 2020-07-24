import { AnimationData } from '../animation'
import { Model, ModelData } from '../model'
import { DrawStage } from '../drawstage'

class MainMenuStage
	name: 'mainmenu'

	constructor: (@gamecore) ->
		@camera = x: 0, y: 0, z: 1

	set: ->
		@gamecore.fill = '#000'
		this

	load: ->
		@drawstage = new DrawStage @gamecore.context, @camera
		mainMenuModel = ModelData.load @gamecore.loader, 'models/main_menu'
		animationData = AnimationData.load @gamecore.loader, 'anims/main_menu'
		@gamecore.loader.on 'load', =>
			@model = new Model mainMenuModel
			@model.animation.set 'main_menu', animationData
			@drawstage.addPart @model, 'main_menu'

	set: ->
		@gamecore.fill = '#99D9EA'

	draw: ->
		@camera.x = @camera.y = 0
		@camera.z = 1
		@model.animation.animate @camera, 'camera'
		@drawstage.draw()

	update: (time, delta) ->
		@model.animation.play time

export { MainMenuStage }