{ lib, stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  pname = "bfr";
  version = "1.6";

  src = fetchurl {
    url = "http://www.sourcefiles.org/Utilities/Text_Utilities/bfr-${version}.tar.bz2";
    sha256 = "0fadfssvj9klj4dq9wdrzys1k2a1z2j0p6kgnfgbjv0n1bq6h4cy";
  };

  patches =
    [ (fetchurl {
        url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/app-misc/bfr/files/bfr-1.6-perl.patch";
        sha256 = "1pk9jm3c1qzs727lh0bw61w3qbykaqg4jblywf9pvq5bypk88qfj";
      })
    ];

  buildInputs = [ perl ];

  meta = with lib; {
    description = "A general-purpose command-line pipe buffer";
    license = lib.licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
