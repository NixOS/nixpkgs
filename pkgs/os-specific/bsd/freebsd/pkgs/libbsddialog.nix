{
  mkDerivation,
  libncurses,
  libncurses-form,
  libncurses-tinfo,
}:
mkDerivation {
  path = "lib/libbsddialog";
  extraPaths = [
    "contrib/bsddialog"
  ];
  outputs = [
    "out"
    "man"
    "debug"
  ];
  buildInputs = [
    libncurses
    libncurses-form
    libncurses-tinfo
  ];
  postFixup = ''
    mv $out/include/private/bsddialog/* $out/include
    rm -rf $out/include/private
  '';
}
