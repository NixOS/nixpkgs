{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "bfr-1.6";
  version = "1.6";

  src = fetchurl {
    url = "http://www.sourcefiles.org/Utilities/Text_Utilities/bfr-${version}.tar.bz2";
    sha256 = "0fadfssvj9klj4dq9wdrzys1k2a1z2j0p6kgnfgbjv0n1bq6h4cy";
  };

  patches =
    [ (fetchurl {
        url = "https://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/app-misc/bfr/files/bfr-1.6-perl.patch?revision=1.1";
        sha256 = "1pk9jm3c1qzs727lh0bw61w3qbykaqg4jblywf9pvq5bypk88qfj";
      })
    ];

  buildInputs = [ perl ];

  meta = with stdenv.lib; {
    description = "A general-purpose command-line pipe buffer";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
