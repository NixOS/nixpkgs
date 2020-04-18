#!/usr/bin/env node

/* Usage:
 * node fixup_yarn_lock.js yarn.lock
 */

const fs = require('fs')
const readline = require('readline')

const urlToName = require('../lib/urlToName')

const yarnLockPath = process.argv[2]

const readFile = readline.createInterface({
  input: fs.createReadStream(yarnLockPath, { encoding: 'utf8' }),

  // Note: we use the crlfDelay option to recognize all instances of CR LF
  // ('\r\n') in input.txt as a single line break.
  crlfDelay: Infinity,

  terminal: false, // input and output should be treated like a TTY
})

const result = []

readFile
  .on('line', line => {
    const arr = line.match(/^ {2}resolved "([^#]+)#([^"]+)"$/)

    if (arr !== null) {
      const [_, url, shaOrRev] = arr

      const fileName = urlToName(url)

      result.push(`  resolved "${fileName}#${shaOrRev}"`)
    } else {
      result.push(line)
    }
  })
  .on('close', () => {
    fs.writeFile(yarnLockPath, result.join('\n'), 'utf8', err => {
      if (err) {
        console.error(
          'fixup_yarn_lock: fatal error when trying to write to yarn.lock',
          err,
        )
      }
    })
  })
