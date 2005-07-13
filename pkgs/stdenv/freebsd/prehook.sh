export NIX_ENFORCE_PURITY=
alias make=gmake
export MAKE=gmake
shopt -s expand_aliases

# Filter out stupid GCC warnings (in gcc-wrapper).
export NIX_GCC_NEEDS_GREP=1
