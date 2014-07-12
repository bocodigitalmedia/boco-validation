# boco-validation

Classes and utilities for object validation.

# Usage

First, you must require the library:

    BocoValidation = require 'boco-validation'
    assert = require 'assert'

## Create a validation object

    subject = foo: null, bar: 'abc'
    validation = new BocoValidation.Validation subject: subject

    assert.equal subject, validation.subject
    assert validation.isValid()

## A typical validation function

    validate = (subject) ->
      validation = new BocoValidation.Validation subject: subject

      unless subject.foo?
        validation.addError 'foo', 'must be present'

      if typeof subject.bar is 'number'

        unless subject.bar > 0
          validation.addError 'bar', 'must be positive'

        unless subject.bar % 2 is 0
          validation.addError 'bar', 'must be even'

      else
        validation.addError 'bar', 'must be a number'

      return validation


## A valid result

    subject = foo: 'some value', bar: 6
    result = validate subject
    assert result.isValid()

## An invalid result

    subject = foo: null, bar: -1
    result = validate subject
    assert result.isInvalid()

## Errors hash

    errors = result.errors

    assert.equal 1, errors.foo.length
    assert.equal 'must be present', errors.foo[0]

    assert.equal 2, errors.bar.length
    assert.equal 'must be positive', errors.bar[0]
    assert.equal 'must be even', errors.bar[1]

    console.log 'ok'
