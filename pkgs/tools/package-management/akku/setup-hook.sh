addToAkkuEnv () {
    addToSearchPathWithCustomDelimiter : CHEZSCHEMELIBDIRS "$1/lib"
}

addEnvHooks "$targetOffset" addToAkkuEnv