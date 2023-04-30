noDeprecatedDeclarations() {
  # Security.framework has about 2000 deprecated constants, all of which the user will be
  # warned about at compilation time
  flag="-Wno-deprecated-declarations"
  if [[ "${NIX_CFLAGS_COMPILE-}" != *$flag* ]]; then
    NIX_CFLAGS_COMPILE+=" $flag"
  fi
}

addEnvHooks "$hostOffset" noDeprecatedDeclarations
