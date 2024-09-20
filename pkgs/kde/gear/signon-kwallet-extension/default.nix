{
  mkKdeDerivation,
  pkg-config,
  signond,
}:
mkKdeDerivation {
  pname = "signon-kwallet-extension";

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [signond];

  # NB: not actually broken, just makes it install to $out instead of $signon/lib/extensions
  extraCmakeFlags = ["-DINSTALL_BROKEN_SIGNON_EXTENSION=1"];
}
