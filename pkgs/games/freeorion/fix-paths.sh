#!/bin/sh

if [ -e ~/.freeorion/config.xml ]; then
  @libxsltBin@/bin/xsltproc -o ~/.freeorion/config.xml @out@/fixpaths/fix-paths.xslt ~/.freeorion/config.xml
fi
exit 0
