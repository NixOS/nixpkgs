{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "patool";
  version = "1.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15qhrc2fl82pyp9w5s2s7d5cihm0zi988qpmysyfsfz1pzw0q673";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://wummel.github.io/patool";
    description = "Portable command line archive file manager";
    license = licenses.gpl3;
    maintainers = [ maintainers.filalex77 ];
  };
}
