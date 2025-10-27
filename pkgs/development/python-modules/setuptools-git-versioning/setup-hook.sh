setSetuptoolsGitVersioningBypassFile() {
  echo "Executing setSetuptoolsGitVersioningBypassFile"
  echo "Version: $version" >> PKG-INFO
}

prePatchHooks+=(setSetuptoolsGitVersioningBypassFile)
