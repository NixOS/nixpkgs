useCoreFoundationFramework () {
  # Avoid overriding value set by the impure CF
  if [ -z "${NIX_COREFOUNDATION_RPATH+x}" ]; then
    export NIX_COREFOUNDATION_RPATH=@out@/Library/Frameworks
  fi
}

addEnvHooks "$hostOffset" useCoreFoundationFramework
