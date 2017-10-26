{ stdenv, fetchurl, bash }:

stdenv.mkDerivation rec {
  name    = "tmin-${version}";
  version = "0.05";

  src = fetchurl {
    url    = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/tmin/${name}.tar.gz";
    sha256 = "0166kcfs4b0da4hs2aqyn41f5l09i8rwxpi20k7x17qsxbmjbpd5";
  };

  buildPhase   = ''
    gcc -O3 -funroll-loops -fno-strict-aliasing -Wno-pointer-sign tmin.c -o tmin
  '';
  installPhase = "mkdir -p $out/bin && mv tmin $out/bin";

  meta = {
    description = "Fuzzing tool test-case optimizer";
    longDescription = ''
      This project is obsolete and replaced by the afl-tmin tool bundled with american fuzzy lop (<literal>afl</literal>)
    '';
    homepage    = "https://code.google.com/archive/p/tmin/";
    license     = stdenv.lib.licenses.asl20;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
    broken      = true; # officially deprecated upstream in favor of afl-tmin (afl package)
  };
}
