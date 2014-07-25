class Validation

  constructor: (props = {}) ->
    @subject = props.subject
    @errors = props.errors

  addError: (key, message) ->
    @errors = {} unless @errors?
    @errors[key] = [] unless @errors[key]?
    @errors[key].push message

  assert: (key, message, test) ->
    @addError key, message unless test @subject[key]

  isInvalid: ->
    @errors? and Object.getOwnPropertyNames(@errors).length > 0

  isValid: ->
    !@isInvalid()

module.exports = Validation
