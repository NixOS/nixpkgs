{ stdenv, fetchurl, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "urlwatch-2.0";

  src = fetchurl {
    url = "http://thp.io/2008/urlwatch/${name}.tar.gz";
    sha256 = "0j38qzw4jxw41vnnpi6j851hqpv8d6p1cbni6cv8r2vqf5307s3b";
  };

  propagatedBuildInputs = with python3Packages; [
    keyring
    minidb
    pyyaml
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
