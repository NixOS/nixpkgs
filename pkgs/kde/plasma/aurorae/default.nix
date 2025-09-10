{
  mkKdeDerivation,
  qttools,
}:
mkKdeDerivation {
  pname = "aurorae";

  patches = [
    # FIXME: upstream
    ./0001-follow-symlinks.patch
  ];

  extraBuildInputs = [ qttools ];
}
