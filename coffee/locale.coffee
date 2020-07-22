class Locale
	@locales: []

	@add: (locales) ->
		loc = @locales
		for k, v of locales
			loc[k] = v

	@text: (text, obj) ->
		text = @locales[text] || text
		if typeof text == 'function'
			text(obj)
		else
			text

	@set: (text, locale) ->
		@locales[text] = locale

export { Locale }