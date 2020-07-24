import { Model, ModelData } from '../model'
import { DrawStage } from '../drawstage'

LOADER_DELAY = 500
RADIUS = 40

modelLoaderData =
	bones:
		loader:
			type: 'arc'
			draw: 's'
			radius: RADIUS
			stroke: '#44f'
			lineWidth: 4
			endAngle: 80
			noClose: true
			angle: 50
			origX: -RADIUS
			origY: -RADIUS

loaderAnimFrame =
	duration: 1
	frames:
		'@loader': [
			{
				start: 0
				end: 1
				to: angle: 360 + 50
			}
		]


class LoadStage
	constructor: (@gamecore) ->
		@camera = x: 0, y: 0, z: 1
		@drawstage = new DrawStage @gamecore.context, @camera
		@model = new Model (new ModelData).loadData @gamecore.loader, modelLoaderData
		@model.animation.setFrame loaderAnimFrame
		@drawstage.addNode @model, 'loader'
		@isloaded = @isLoad = true

	set: ->
		@gamecore.fill = '#000'
		this

	setStage: (stage) ->
		@stage =
			if typeof stage == 'string'
				@gamecore.stages[stage]
			else stage
		@gamecore.setStage this
		@load()

	load: ->
		if stage = @stage
			unless stage.isLoad
				stage.isLoad = true
				stage.load?()
			unless stage.isLoaded
				@gamecore.loader.on 'load', =>
					stage.isloaded = true
					setTimeout (=> @gamecore.setStage stage), LOADER_DELAY
					@gamecore.loader.off 'load'

	draw: ->
		@drawstage.draw()

	update: (time, delta) ->
		@model.animation.play time
	
export { LoadStage }