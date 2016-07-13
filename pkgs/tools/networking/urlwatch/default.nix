{ stdenv, fetchurl, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "urlwatch-2.2";

  src = fetchurl {
    url = "http://thp.io/2008/urlwatch/${name}.tar.gz";
    sha256 = "0s9056mm1hkj5gpzsb5bz6fwxk0nm73i0dhnqwa1bfddjnvpl9d3";
  };

  patches = [
    ./setup.patch
  ];

  propagatedBuildInputs = with python3Packages; [
    keyring
    minidb
    pyyaml
    requests2
  ];

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
