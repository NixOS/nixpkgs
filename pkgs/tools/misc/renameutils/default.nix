{lib, stdenv, fetchurl, readline}:

stdenv.mkDerivation rec {
  pname = "renameutils";
  version = "0.12.0";

  src = fetchurl {
    url = "mirror://savannah/renameutils/renameutils-${version}.tar.gz";
    sha256 = "18xlkr56jdyajjihcmfqlyyanzyiqqlzbhrm6695mkvw081g1lnb";
  };

  patches = [ ./install-exec.patch ];

  nativeBuildInputs = [ readline ];

  meta = {
    homepage = "https://www.nongnu.org/renameutils/";
    description = "A set of programs to make renaming of files faster";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Plus;
  };
}
