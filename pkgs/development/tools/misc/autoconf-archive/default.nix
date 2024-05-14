{ lib, stdenv, fetchurl, xz, texinfo }:

stdenv.mkDerivation rec {
  pname = "autoconf-archive";
  version = "2023.02.20";

  src = fetchurl {
    url = "mirror://gnu/autoconf-archive/autoconf-archive-${version}.tar.xz";
    hash = "sha256-cdQEhHmuKPH1eUYZw9ct+cAd9JscYo74X943WW3DGjM=";
  };

  strictDeps = true;
  enableParallelBuilding = true;

  buildInputs = [ xz ];
  # texinfo being required on FreeBSD precipitates from the autotoolsAbspathHook.
  # by patching the impure uname path on the FreeBSD code path, this triggers a
  # file-was-modified check which rebuilds some doc information requiring texinfo.
  nativeBuildInputs = lib.optionals stdenv.buildPlatform.isFreeBSD [ texinfo ];

  meta = with lib; {
    description = "Archive of autoconf m4 macros";
    homepage = "https://www.gnu.org/software/autoconf-archive/";
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
