path = require 'path'
fs = require 'fs'
CSON = require 'season'
config = require './config'

module.exports =
class Linker
  run: (options) ->
    linkPath = path.resolve(process.cwd(), options.commandArgs.shift() ? '.')
    try
      packageName = CSON.readFileSync(CSON.resolve(path.join(linkPath, 'package'))).name
    catch error
      packageName = path.basename(linkPath)

    targetPath = path.join(config.getAtomDirectory(), 'packages', packageName)
    try
      if fs.existsSync(targetPath)
        fs.unlinkSync(targetPath)
      else
        fs.symlinkSync(linkPath, targetPath)
      console.log "#{targetPath} -> #{linkPath}"
    catch error
      console.error("Linking #{targetPath} to #{linkPath} failed")
      options.callback(error)
