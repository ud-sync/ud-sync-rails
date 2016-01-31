# ud_sync_rails [![Build Status](https://travis-ci.org/ud-sync/ud-sync-rails.svg?branch=master)](https://travis-ci.org/ud-sync/ud-sync-rails)

ud-sync is a set of tools to allow client applications to work offline. This gem
will help you on the server.

This gem will plug into your Rails models and save every DB operation.
With that information, it will expose `GET /ud_sync/operations` so that your
mobile devices can come from offline and know what data was deleted in other
devices, synchronizing automatically.

We're aiming at building the client counterparts. Check the
[ud-sync](https://github.com/ud-sync) organization for other languages
(e.g [ud-sync-swift](Swift)).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ud_sync'
```

And then execute:

    $ bundle

## Usage

**Step 1: runs migrations**

```
rake db:migrate
```

`ud-sync` records operations and configurations in database tables.

**Step 2: add the route**

```ruby
Rails.application.routes.draw do
  mount UdSync::Engine => "/ud_sync"

  # ...
end
```

**Step 3: configure your models**

```ruby
class Post < ActiveRecord::Base
  ud_sync

  # ...
end
```

Whenever you save or delete a post, this will save the operation automatically.

**Step 4: consume /ud_sync/operations**

When you access `GET /ud_sync/operations`, you will get a response such as the
following.

```json
{
  "operations": [{
    "id": 1,
    "name": "save",
    "record_id": "record-1",
    "entity": "User",
    "date": "2025-10-23T10:32:41Z"
  }, {
    "id": 2,
    "name": "delete",
    "record_id": "record-2",
    "entity": "Post",
    "date": "2025-10-23T11:23:23Z"
  }]
}
```

`name` stands for the name of the operation, which could be `save` or `delete`.
`record_id` is the id of the record that was processed. `entity` is the resource
name and `date` when it happened.

For example, when DeviceA running your offline ready mobile app deletes Post
with id `record-2`, this operation will be recorded. When DeviceB comes online,
it will request the operations endpoint and check that the Post was deleted
online. It will then delete it locally so that it's synchronized with DeviceA.

**Step 5: define current_user in your application controller**

If your `ApplicationController` has `current_user` defined, `GET /operations`
will only return Operations which `owner_id` equals `current_user.id`

### Customizing ud-sync-rails

You can customize it by changing `ud_sync` call:

```ruby
class Post < ActiveRecord::Base
  belongs_to :user

  ud_sync entity: 'Article', id: :uuid, owner: :user
  # ...
end
```

`entity` is the name of the resource. If not specified, the name of the model
class will be used. `id` is the attribute you want to use as id - for example,
when you use uuids, you might not want to expose your internal ids. `owner`
is the association that represents the user that has the current resource. With
that, you can return only the operations belonging to the current user.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake` to run the tests.

### Testing

When adding a new attribute via migration, do the following to clean up the
cache:

```
bin/setup
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/ud-sync-rails.

