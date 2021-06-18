{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "pax-utils";
  version = "1.2.9";

  src = fetchurl {
    url = "http://distfiles.gentoo.org/distfiles/${pname}-${version}.tar.xz";
    sha256 = "sha256-687CadybmHbXO9M6jQDVZ+OUat6U2XDVyysM/KwpiLI=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "ELF utils that can check files for security relevant properties";
    longDescription = ''
      A suite of ELF tools to aid auditing systems. Contains
      various ELF related utils for ELF32, ELF64 binaries useful
      for displaying PaX and security info on a large groups of
      binary files.
    '';
    homepage = "https://wiki.gentoo.org/wiki/Hardened/PaX_Utilities";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice joachifm ];
  };
}
