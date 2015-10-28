noDeprecatedDeclarations() {
  # Security.framework has about 2000 deprecated constants, all of which the user will be
  # warned about at compilation time
  NIX_CFLAGS_COMPILE+=" -Wno-deprecated-declarations"
}

envHooks+=(noDeprecatedDeclarations)
