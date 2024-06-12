forceLinkCoreFoundationFramework() {
  local role_post
  getHostRole

  local cflags_compile_role_var="NIX_CFLAGS_COMPILE${role_post}"
  local cflags_compile_role="${!cflags_compile_role_var-}"
  export NIX_CFLAGS_COMPILE${role_post}="-F@out@/Library/Frameworks${cflags_compile_role:+ $cflags_compile_role}"

  local ldflags_role_var="NIX_LDFLAGS${role_post}"
  local ldflags_role="${!ldflags_role_var-}"
  export NIX_LDFLAGS${role_post}+="${ldflags_role:+ }@out@/Library/Frameworks/CoreFoundation.framework/CoreFoundation.tbd"
}

forceLinkCoreFoundationFramework
