{stdenv, fetchurl}:
stdenv.mkDerivation {
  name = "unrar";

  src = fetchurl {
    sha256 = "0inzy0jlwqm18i6lq17aq4n2baqqlbjyr6incw4s9cxrvmjq51ls";
    url = http://www.rarlab.com/rar/unrarsrc-3.7.6.tar.gz;
  };

  makeFlags = "-f makefile.unix";

  installPhase = "mkdir -p \${out}/bin/ ; cp unrar \${out}/bin/;";

  buildInputs = [];
}
