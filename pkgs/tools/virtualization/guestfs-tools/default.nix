{ lib
, stdenv
, fetchurl
, bison
, cdrkit
, cpio
, flex
, getopt
, hivex
, jansson
, libguestfs
, libvirt
, libxml2
, makeWrapper
, ncurses
, ocamlPackages
, pcre2
, perlPackages
, pkg-config
, qemu
, xz
}:

stdenv.mkDerivation rec {
  pname = "guestfs-tools";
  version = "1.48.2";

  src = fetchurl {
    url = "https://download.libguestfs.org/guestfs-tools/${lib.versions.majorMinor version}-stable/guestfs-tools-${version}.tar.gz";
    sha256 = "sha256-G9l5sG5g5kMlSXzg0GX8+Et7M9/k2dRLMBgsMI4MaxA=";
  };

  nativeBuildInputs = [
    bison
    cdrkit
    cpio
    flex
    getopt
    makeWrapper
    pkg-config
    qemu
  ] ++
  (with perlPackages; [
    GetoptLong
    libintl-perl
    ModuleBuild
    perl
    Po4a
  ]) ++
  (with ocamlPackages; [
    findlib
    gettext-stub
    ocaml
    ocaml_gettext
    ounit2
  ]);

  buildInputs = [
    hivex
    jansson
    libguestfs
    libvirt
    libxml2
    ncurses
    pcre2
    xz
  ];

  enableParallelBuilding = true;

  preBuild = ''
    patchShebangs .
  '';

  postInstall = ''
    wrapProgram $out/bin/virt-win-reg \
      --prefix PERL5LIB : ${with perlPackages; makeFullPerlPath [ hivex libintl-perl libguestfs ]}
  '';

  meta = with lib; {
    description = "Extra tools for accessing and modifying virtual machine disk images";
    license = with licenses; [ gpl2Plus lgpl21Plus ];
    homepage = "https://libguestfs.org/";
    maintainers = with maintainers; [ thiagokokada ];
    platforms = platforms.linux;
  };
}
