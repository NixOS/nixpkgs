addNodePath () {
    addToSearchPath NODE_PATH $1/node_modules
}

envHooks=(${envHooks[@]} addNodePath)
