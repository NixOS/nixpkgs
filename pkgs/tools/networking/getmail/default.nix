{ stdenv, fetchurl, buildPythonPackage }:

buildPythonPackage rec {
  name = "getmail-4.20.0";
  namePrefix = "";

  src = fetchurl {
    url = "http://pyropus.ca/software/getmail/old-versions/${name}.tar.gz";
    sha256 = "17cpyra61virk1d223w8pdwhv2qzhbwdbnrr1ab1znf4cv9m3knn";
  };

  doCheck = false;

  installCommand = "python setup.py install --prefix=\"\$prefix\"";
  
  meta = {
    description = "A program for retrieving mail";
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.linux;
  };
}
