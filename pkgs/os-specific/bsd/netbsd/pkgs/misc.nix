{ mkDerivation, defaultMakeFlags }:

mkDerivation {
  path = "share/misc";
  noCC = true;
  version = "9.2";
  sha256 = "1j2cdssdx6nncv8ffj7f7ybl7m9hadjj8vm8611skqdvxnjg6nbc";
  makeFlags = defaultMakeFlags ++ [ "BINDIR=$(out)/share" ];
}
