import { GameCore } from './gamecore'
import { Loader } from './loader'

$(document).ready ->
	$canvas = $ '#canvas'
	$gamescreen = $ '.gamescreen'
	canvas = $canvas.get 0
	context = canvas.getContext '2d', alpha: false

	resize = ->
		canvas.width = $(window).width()
		canvas.height = $(window).height()

	resize()

	$(window).on 'resize', resize

	gamecore = new GameCore canvas, context
	gamecore.load()
	gamecore.render()
	window.gamecore = gamecore

	# camera = gamecore.camera

	# oldMouseX = oldMouseY =0
	# moveCamera = (e) ->
	# 	camera.x += e.clientX - oldMouseX
	# 	camera.y += e.clientY - oldMouseY
	# 	oldMouseX = e.clientX
	# 	oldMouseY = e.clientY

	# $gamescreen.on 'mousedown', (e) ->
	# 	oldMouseX = e.clientX
	# 	oldMouseY = e.clientY
	# 	$gamescreen.on 'mousemove', moveCamera

	# $gamescreen.on 'touchstart', (e) ->
	# 	oldMouseX = e.touches[0].clientX
	# 	oldMouseY = e.touches[0].clientY

	# $gamescreen.on 'touchmove', (e) ->
	# 	moveCamera e.touches[0]

	# $gamescreen.on 'mouseup', ->
	# 	$gamescreen.off 'mousemove', moveCamera

	$('.js-stop-propagation').on 'mousedown mouseup mousemove touchstart touchmove', (e) ->
		e.stopPropagation()

	launchFullScreen = (element) ->
		element.requestFullScreen?()
		element.mozRequestFullScreen?()
		element.webkitRequestFullScreen?()

	cancelFullscreen = ->
		document.cancelFullScreen?()
		document.mozCancelFullScreen?()
		document.webkitCancelFullScreen?()

	$('.btn-fullscreen').click ->
		launchFullScreen document.documentElement