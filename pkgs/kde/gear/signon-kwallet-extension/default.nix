{
  mkKdeDerivation,
  pkg-config,
  signond,
}:
mkKdeDerivation {
  pname = "signon-kwallet-extension";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [ signond ];

  # NB: not actually broken, just makes it install to $out instead of $signon/lib/extensions
  # This is useless without a wrapped signond.
  # FIXME: wrap signond with SSO_EXTENSIONS_DIR=$wrapper/lib/extensions
  extraCmakeFlags = [ "-DINSTALL_BROKEN_SIGNON_EXTENSION=1" ];
}
