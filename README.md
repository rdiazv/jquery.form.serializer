# jQuery Form Validation

This jQuery extension provides an easy way to serialize HTML forms into JSON.

By default the serialization it's based on the submittable fields according to [W3C Successful controls](http://www.w3.org/TR/html401/interact/forms.html#h-17.13.2), but this is easily customizable to fit your needs.

The following elements are always ignored:

* Elements without a `name` attribute.
* File inputs.
* Buttons.

## Installation

Include `jquery.form.serializer.min.js` after `jquery.js`.

```html
<script type="text/javascript" src="jquery.js"></script>
<script type="text/javascript" src="jquery.form.serializer.min.js"></script>
```

## Usage

Based on a form like this one:

```html
<form id="my-form">
  <input type="hidden" name="token" value="ABC" />
  <input type="text" name="user[name]" value="John Doe" />
  <input type="text" name="user[email]" value="john@email.com" />
  <select name="user[country]">
    <option value="CL" selected>Chile</option>
  </select>
</form>
```

Serialize the form into JSON:

```javascript
$("#my-form").getSerializedForm();

// =>
{
  token: "ABC",
  user: {
    name: "John Doe",
    email: "john@email.com",
    country: "CL"
  }
}
```

## Submittable Fields

The submittable fields are initially selected using:

```javascript
$.jQueryFormSerializer.submittable = 'input, select, textarea';
```

The initial matched set it's reduced passing every function defined in `$.jQueryFormSerializer.filters` to the [filter function](http://api.jquery.com/filter/).

There are two default filters:

* `enabledOnly`: Disabled fields won't be serialized.
* `checkedOnly`: Only checked `input[type="checkbox"]` and `input[type="radio"]` will be serialized.

## Value Castings

Value castings are defined in `$.jQueryFormSerializer.castings`, and allows you to preprocess a field value before serializing it.

The only default value casting it's `booleanCheckbox`, that returns `true` or `false` on checkboxes without an explicit `value` attribute.

## Customization

Any option declared in `$.jQueryFormSerializer` can be overwritten if you need a global customization, or you can pass a hash of options to `getSerializedForm` that will [extend](http://api.jquery.com/jquery.extend/) `$.jQueryFormSerializer`, allowing to change the defaults only for one call.

### Examples

Always allow disabled fields to be serialized:

```javascript
$.jQueryFormSerializer.filters.enabledOnly = false;
```

Allow unchecked fields to be serialized only for this call:

```javascript
$("#my-form").getSerializedForm({
  filters: {
    checkedOnly: false
  }
});
```

Add a new filter to avoid serializing fields with `.disabled`:

```javascript
$.jQueryFormSerializer.filters.disabledByClass = function() {
  return !$(this).hasClass("disabled");
};
```

Add a new value casting for numeric fields:

```javascript
$("#my-form").getSerializedForm({
  castings: {
    numericField: function() {
      if ($(this).hasClass("numeric")) {
        return parseInt($(this).val());
      }
    }
  }
});
```

The same applies to `filters`, `castings` and the `submittable` selector.

### Custom Controls

You can easily integrate any custom control for serialization. For example, given this custom control:

```html
<form id="my-form">
  <div class="custom-control" name="my-custom-control" data-custom-value="my value"></div>
</form>
```

```javascript
$.valHooks.custom_control = {
  get: function(el) {
    return $(el).data("custom-value");
  },
  set: function(el, value) {
    return $(el).data({ "custom-value": value });
  }
};

$.fn.customControl = function() {
  return $(this).each(function() {
    this.type = "custom_control";

    // All your custom control magic...
  });
};

$(function() {
  $(".custom-control").customControl();
});
```

Add your custom control to the global configuration:

```javascript
$.jQueryFormSerializer.submittable += ", .custom-control"
```

And that's it!

```javascript
$("#my-form").getSerializedForm(); // => { "my-custom-control": "my value" }

$(".custom-control").addClass("disabled");
$("#my-form").getSerializedForm(); // => {}
```

## Tests

Run `npm install` and `npm test`, or if you don't have [Node.js](http://nodejs.org/) installed, open `./specs/index.html` on any browser.
