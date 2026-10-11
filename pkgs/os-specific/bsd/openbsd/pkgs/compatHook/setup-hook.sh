useOpenBSDCompat () {
  export NIX_CFLAGS_COMPILE_@suffixSalt@+="-I@compat@/include"
}

postHooks+=(useOpenBSDCompat)
