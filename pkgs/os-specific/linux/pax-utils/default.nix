{ stdenv
, lib
, fetchurl
, buildPackages
, docbook_xml_dtd_44
, docbook_xsl
, withLibcap ? stdenv.isLinux, libcap
, pkg-config
, meson
, ninja
, xmlto
, python3

, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "pax-utils";
  version = "1.3.7";

  src = fetchurl {
    url = "mirror://gentoo/distfiles/${pname}-${version}.tar.xz";
    sha256 = "sha256-EINi0pZo0lz3sMrcY7FaTBz8DbxxrcFRszxf597Ok5o=";
  };

  strictDeps = true;

  mesonFlags = [
    (lib.mesonEnable "use_libcap" withLibcap)
  ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [ docbook_xml_dtd_44 docbook_xsl meson ninja pkg-config xmlto ];
  buildInputs = lib.optionals withLibcap [ libcap ];
  # Needed for lddtree
  propagatedBuildInputs = [ (python3.withPackages (p: with p; [ pyelftools ])) ];

  passthru.updateScript = gitUpdater {
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
