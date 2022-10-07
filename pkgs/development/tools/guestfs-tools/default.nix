{ lib
, stdenv
, fetchurl
, pkg-config
, libguestfs-with-appliance
, ncurses
, cpio
, cdrkit
, flex
, bison
, qemu
, hivex
, bash-completion
, pcre2
, libxml2
, libvirt
, jansson
, getopt
, perlPackages
, ocamlPackages
, xz
, openssl
}:

stdenv.mkDerivation rec {
  pname = "guestfs-tools";
  version = "1.48.2";

  src = fetchurl {
    url = "https://download.libguestfs.org/guestfs-tools/${lib.versions.majorMinor version}-stable/${pname}-${version}.tar.gz";
    sha256 = "sha256-G9l5sG5g5kMlSXzg0GX8+Et7M9/k2dRLMBgsMI4MaxA=";
  };

  nativeBuildInputs = [
    bison
    cdrkit
    cpio
    flex
    getopt
    pkg-config
    qemu
  ] ++ (with perlPackages; [ perl libintl-perl GetoptLong ModuleBuild ])
    ++ (with ocamlPackages; [ ocaml findlib ]);
  buildInputs = [
    libguestfs-with-appliance
    ncurses
    jansson
    pcre2
    hivex
    libxml2
    libvirt
    bash-completion
    xz
    openssl
  ] ++ (with ocamlPackages; [ ocamlbuild ocaml_libvirt gettext-stub ounit2 ]);

  postPatch = ''
    patchShebangs ocaml-dep.sh.in ocaml-link.sh.in run.in
  '';

  makeFlags = [ "LIBGUESTFS_PATH=${libguestfs-with-appliance}/lib/guestfs" ];

  installFlags = [
    "BASH_COMPLETIONS_DIR=${placeholder "out"}/share/bash-completion/completions"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Tools for accessing and modifying virtual machine disk images";
    license = with licenses; [ gpl2Plus lgpl21Plus ];
    homepage = "https://libguestfs.org/";
    maintainers = with maintainers; [ offline astro ];
    platforms = platforms.linux;
  };
}
