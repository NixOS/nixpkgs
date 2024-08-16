addNodePath () {
    addToSearchPath NODE_PATH "$1/lib/node_modules"
}

addEnvHooks "$hostOffset" addNodePath

nodejs_nodedir_postHook() {
    # Set Node.js header path for node-gyp that needs include/node/common.gypi.
    # https://github.com/nodejs/node-gyp/blob/e6f4ede10cca28e9edeaa85d7830914c5d1499c7/lib/configure.js#L251-L256
    export npm_config_nodedir=@include@
}

# Only when nodejs is in buildInputs or equivalent, unless strictDeps is not set.
if [[ -z $strictDeps || $hostOffset -gt 0 ]]; then
    postHooks+=(nodejs_nodedir_postHook)
fi
