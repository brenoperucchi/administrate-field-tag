# Administrate::Field::Tag

Adds a Tag field to [Administrate].

It's intended as a way to organize tags without needing a second TagDashboard to create and/or manage them.

It will automatically create, add and remove tags ( or any other attribute that functions similarly ).

It will never destroy tags to avoid potentially breaking an application where tags are referenced in unforeseen ways.

It uses [Selectize] to provide tag inputs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'administrate-field-tag', git: 'git@git.noxqsapp.nl:gems/administrate-field-tag.git'
```

And then execute:

    $ bundle

## Usage

Set your ATTRIBUTE_TYPE to Field::Tag.

Tries to get the options through i18n if not passed along. So [rails-i18n] would be helpful here.

| Options         | Description |
| --------------- | ----------- |
| :class_name     | Sets the Tag class, defaults to "Tag". |
| :attribute_name | Sets the name of the attribute to display and enter on the Tag class, defaults to :name. |


Example if you have a Category model with a title attribute.
```ruby
ATTRIBUTE_TYPES = {
  price: Field::Tag.with_options(class_name: 'Category', attribute_name: :title)
}
```

### Note

Needs jQuery and expects it to already be loaded.

[Administrate]: https://github.com/thoughtbot/administrate
[Selectize]: https://selectize.github.io/selectize.js/
