{stdenv, fetchurl, jdk, swt}:

stdenv.mkDerivation {
  name = "azureus-2.3.0.6";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nixos.org/tarballs/Azureus2.3.0.6.jar;
    md5 = "84f85b144cdc574338c2c84d659ca620";
  };
#  buildInputs = [unzip];
  inherit jdk swt;
}
