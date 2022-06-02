{ stdenv, lib, fetchurl, bash, gitUpdater }:

stdenv.mkDerivation rec {
  pname = "pax-utils";
  version = "1.3.4";

  src = fetchurl {
    url = "mirror://gentoo/distfiles/${pname}-${version}.tar.xz";
    sha256 = "sha256-i67S+cWujgzaG5x1mQhkEBr8ZPrQpGFuEPP/jviRBAs=";
  };

  strictDeps = true;

  buildInputs = [ bash ];

  makeFlags = [ "PREFIX=$(out)" ];

  passthru.updateScript = gitUpdater {
    inherit pname version;
    url = "https://anongit.gentoo.org/git/proj/pax-utils.git";
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "ELF utils that can check files for security relevant properties";
    longDescription = ''
      A suite of ELF tools to aid auditing systems. Contains
      various ELF related utils for ELF32, ELF64 binaries useful
      for displaying PaX and security info on a large groups of
      binary files.
    '';
    homepage = "https://wiki.gentoo.org/wiki/Hardened/PaX_Utilities";
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice joachifm ];
  };
}
