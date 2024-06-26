{
  mkKdeDerivation,
  qt5compat,
  qttools,
  acl,
  attr,
}:
mkKdeDerivation {
  pname = "kio";

  patches = [
    # Remove hardcoded smbd search path
    ./0001-Remove-impure-smbd-search-path.patch
    # When running a process through systemd, resolve the full path ourselves
    ./early-resolve-executables.diff
    # FIXME(later): discuss with upstream?
  ];

  extraBuildInputs = [qt5compat qttools acl attr];
}
