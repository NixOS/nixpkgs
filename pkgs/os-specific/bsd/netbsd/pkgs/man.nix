{ mkDerivation, defaultMakeFlags }:

mkDerivation {
  path = "share/man";
  noCC = true;
  # man0 generates a man.pdf using ps2pdf, but doesn't install it later,
  # so we can avoid the dependency on ghostscript
  postPatch = ''
    substituteInPlace $COMPONENT_PATH/man0/Makefile --replace "ps2pdf" "echo noop "
  '';
  makeFlags = defaultMakeFlags ++ [
    "FILESDIR=$(out)/share"
    "MKRUMP=no" # would require to have additional path sys/rump/share/man
  ];
}
