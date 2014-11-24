{ stdenv, fetchurl, python3Packages }:

python3Packages.buildPythonPackage rec {
  name = "urlwatch-1.17";

  src = fetchurl {
    url = "http://thp.io/2008/urlwatch/${name}.tar.gz";
    sha256 = "1xl8gi01bfbrg2mchns9cgagpxjjsig1x4kis3isqgfg4k0h8vq0";
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
