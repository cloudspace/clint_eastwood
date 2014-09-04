# ClintEastwood

The **C** loudspace **Lint** er for rails applications

## Installation

Add this line to your application's Gemfile:

    gem 'clint_eastwood'

And then execute:

    $ bundle

## Usage

To run simply run `clint` while in the desired app root directory.

## options
#### Path
Allows to to specify a project path other than the current directory

```
clint --path /path/to/my/project
```

#### Lint
Allows you to specify which subdirectories to lint (default is `app`, `lib`, `config`, `spec`)

```
clint --lint app lib bin
```

#### Disable modules
The following options are availabe to disable the individual linter modules

```
--disable-reek
--disable-rubocop
--disable-rbp
```

#### Warn only
Runs clint but still exists successfully, only printing the output

```
clint --warn
```


## Contributing

1. Fork it ( https://github.com/cloudspace/clint_eastwood/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
