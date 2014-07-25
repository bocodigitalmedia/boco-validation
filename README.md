# boco-validation

Classes and utilities for object validation.

    BocoValidation = require 'boco-validation'
    assert = require 'assert'

# Validation class

    Validation = BocoValidation.Validation

The validation class encapsulates the `errors` pertaining to the validation of a given `subject`.

    subject = foo: null, bar: 'abc'
    validation = new Validation subject: subject
    assert.equal subject, validation.subject

By default all validations are "valid".

    assert validation.isValid()

## Adding errors

Validations become "invalid" when errors are added.

    validation.addError "foo", "must be present" unless subject.foo?
    assert validation.isInvalid()

## Making assertions

Errors can also be added by making assertions on the subject's properties.

    validation = new Validation subject: subject
    validation.assert "foo", "must be present", (foo) -> foo?
    assert validation.isInvalid()

# An example validation method

Here we have a validation method that validates an object with the following rules:

* `foo` must be present
* `bar` must be number
  * if it is a number, it must be positive
  * if it is a number, it must also be even

---

    validate = (subject) ->

      isPresent = (value) -> value?
      isPositive = (n) -> n > 0
      isNumber = (n) -> typeof n is 'number'
      isEven = (n) -> n % 2 is 0

      validation = new Validation subject: subject

      validation.assert "foo", "must be present", isPresent

      if isNumber subject.bar
        validation.assert "bar", "must be positive", isPositive
        validation.assert "bar", "must be even", isEven
      else
        validation.addError "bar", "must be a number"

      return validation


Here's an example of a valid subject:

    validation = validate foo: 'foo', bar: 6
    assert validation.isValid()

And here, we have an invalid subject:

    validation = validate foo: null, bar: -1
    assert validation.isInvalid()

# Errors

Let's use the above `validate` method to get a validation with some errors:

    validation = validate foo: null, bar: -1
    assert validation.isInvalid()

The validation `errors` property has keys that reflect subject property names,  the values of which are simple arrays of error messages.

    errors = validation.errors

    assert.equal 1, errors.foo.length
    assert.equal 'must be present', errors.foo[0]

    assert.equal 2, errors.bar.length
    assert.equal 'must be positive', errors.bar[0]
    assert.equal 'must be even', errors.bar[1]
