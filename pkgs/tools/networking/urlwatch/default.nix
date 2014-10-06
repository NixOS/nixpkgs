{ stdenv, fetchurl, python3Packages }:

python3Packages.buildPythonPackage rec {
  name = "urlwatch-1.16";

  src = fetchurl {
    url = "http://thp.io/2008/urlwatch/${name}.tar.gz";
    sha256 = "0yf1m909awfm06z7xwn20qxbbgslb1vjwwb6rygp6bn7sq022f1f";
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
