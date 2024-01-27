linkSystemCoreFoundationFramework() {
  local role_post
  getHostRole

  local cflags_compile_role_var="NIX_CFLAGS_COMPILE${role_post}"
  local cflags_compile_role="${!cflags_compile_role_var-}"
  export NIX_CFLAGS_COMPILE${role_post}="-F@out@/Library/Frameworks${cflags_compile_role:+ $cflags_compile_role}"

  # gross! many symbols (such as _OBJC_CLASS_$_NSArray) are defined in system CF, but not
  # in the opensource release
  # if the package needs private headers, we assume they also want to link with system CF
  local ldflags_role_var="NIX_LDFLAGS${role_post}"
  local ldflags_role="${!ldflags_role_var-}"
  export NIX_LDFLAGS${role_post}+="${ldflags_role:+ }@out@/Library/Frameworks/CoreFoundation.framework/CoreFoundation.tbd"
}

linkSystemCoreFoundationFramework
