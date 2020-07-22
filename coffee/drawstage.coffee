import { Model } from './model'

class DrawStage

	constructor: (@context, @camera) ->
		@objects = []

	sort: ->
		@objects = @objects.sort (a, b) ->
			a.getZ() - b.getZ()
		this

	addPart: (model, part, v) ->
		if model.data?.parts
			v = v || x: 0, y: 0, z: 1
			p = new PartObject model, part, v
			@objects.push p
		this

	addNode: (model, node, v) ->
		v = v || x: 0, y: 0, z: 1
		if model.data?.bones
			nObj = new NodeObject model, node, v
			@objects.push nObj

	addGroup: (drawgroup) ->
		@objects.push drawgroup
		this

	delete: (model) ->
		delete model.nodeObj
		@objects = @objects.filter (obj) ->
			obj.model != model
		this

	draw: ->
		for obj in @objects
			obj.draw this
		this

tVector = x: 0, y: 0, z: 1

class PartObject
	constructor: (@model, @part, @v) ->

	setPos: (v) ->
		@v.x = v.x
		@v.y = v.y
		@v.z = v.z
		this

	getZ: ->
		@part.z + @v.z

	draw: (stage) ->
		c = stage.camera
		g = stage.context
		tVector.x = @v.x + c.x
		tVector.y = @v.y + c.y
		tVector.z = @v.z * c.z
		g.save()
		if @scale then g.scale @scale, @scale
		@model.drawPart g, @part, tVector, @opacity
		g.restore()

class NodeObject
	constructor: (@model, @node, @v) ->

	setPos: (v) ->
		@v.x = v.x
		@v.y = v.y
		@v.z = v.z
		this

	getZ: ->
		@v.z

	draw: (stage) ->
		c = stage.camera
		g = stage.context
		v = @v
		g.save()
		Model.transform(v.x, v.y, v.z, c)
			.apply g
		if @scale then g.scale @scale, @scale
		@model.drawNode g, @node, @opacity
		g.restore()

export { DrawStage }