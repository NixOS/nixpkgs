{ stdenv, fetchurl, python3Packages }:

python3Packages.buildPythonPackage rec {
  name = "urlwatch-1.18";

  src = fetchurl {
    url = "http://thp.io/2008/urlwatch/${name}.tar.gz";
    sha256 = "090qfgx249ks7103sap6w47f8302ix2k46wxhfssxwsqcqdl25vb";
  };

  patchPhase = ''
    ./convert-to-python3.sh
  '';

  postFixup = ''
    wrapProgram "$out/bin/urlwatch" --prefix "PYTHONPATH" : "$PYTHONPATH"
  '';

  meta = {
    description = "A tool for monitoring webpages for updates";
    homepage = https://thp.io/2008/urlwatch/;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.tv ];
  };
}
