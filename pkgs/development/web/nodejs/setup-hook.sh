addNodePath () {
    appendToSearchPath NODE_PATH "$1/lib/node_modules"
}

addEnvHooks "$hostOffset" addNodePath
