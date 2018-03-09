# Ftphelper
### Boom! no more hassle with ftp in vim
Ftphelper is a plugin that solves some of the issues I had with ftp hosts. Using it is as simple as writing four lines of text. Literally!

## Requirements
* a computer
* vim
* lftp installed

## Usage
To use Ftphelper a file named **.conn** needs to exist describing the connection info. host username and password in that order, on seperate lines.
```
ftp.example.com
user
password123
```
Having this file in the working directory will enable ftphelper.
You can call :PullFtp to mirror the specified host and :PushFtp to upload all files with a newer timestamp than the remote file.
Whenever writing a buffer ftphelper will upload the saved file automaticly.

ftphelper supports basic file/folder inclusion and exclusion.
These rules are glob expressions that are defined in two arrays: **g:ftphelper_excludes** and **g:ftphelper_includes**.
```vim
let g:ftphelper_excludes = ['*.git/', '*js/editors/', '*ext/', '*Payment/', '*fonts/', '*images/', '*logs/', '*files/']
let g:ftphelper_includes = ['*.conf', '*.css', '*.html', '*.ini', '*.js', '*.json', '*.php', '*.txt', '*.tpl']
```

## Todo
- [ ] Support more protocol types
- [ ] Add support for mirroring without includes (At the moment it ignores everything unless specified different in g:ftphelper_includes)
- [x] Dont upload .conn on save
- [x] Remove the hook function from autoload
- [ ] Add check if file is part of the pwd. If not dont upload it.
- [ ] Write a vim doc file.
