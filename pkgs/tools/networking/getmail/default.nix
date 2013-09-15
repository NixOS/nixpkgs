{ stdenv, fetchurl, buildPythonPackage }:

buildPythonPackage rec {
  name = "getmail-4.42.0";
  namePrefix = "";

  src = fetchurl {
    url = "http://pyropus.ca/software/getmail/old-versions/${name}.tar.gz";
    sha256 = "0n6sxp8vwa19ffr7bagzwp0hvxfjiy43xpz9sa1qmsyjs7c3xdqj";
  };

  doCheck = false;

  installCommand = "python setup.py install --prefix=\"\$prefix\"";
  
  meta = {
    description = "A program for retrieving mail";
    maintainers = [ stdenv.lib.maintainers.raskin stdenv.lib.maintainers.iElectric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
