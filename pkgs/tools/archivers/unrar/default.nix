{stdenv, fetchurl}:
stdenv.mkDerivation {
  name = "unrar-3.7.6";

  src = fetchurl {
    url = http://www.rarlab.com/rar/unrarsrc-3.7.6.tar.gz;
    sha256 = "0inzy0jlwqm18i6lq17aq4n2baqqlbjyr6incw4s9cxrvmjq51ls";
  };

  makeFlags = "-f makefile.unix";

  installPhase = "mkdir -p \${out}/bin/ ; cp unrar \${out}/bin/;";

  buildInputs = [];
}
