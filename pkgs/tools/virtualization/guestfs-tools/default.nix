{ lib
, stdenv
, fetchurl
, bash-completion
, bison
, cdrkit
, cpio
, curl
, flex
, getopt
<<<<<<< HEAD
, glib
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, gnupg
, hivex
, jansson
, libguestfs-with-appliance
<<<<<<< HEAD
, libosinfo
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, libvirt
, libxml2
, makeWrapper
, ncurses
, ocamlPackages
, openssl
, pcre2
, perlPackages
, pkg-config
, qemu
, xz
}:

stdenv.mkDerivation rec {
  pname = "guestfs-tools";
<<<<<<< HEAD
  version = "1.50.1";

  src = fetchurl {
    url = "https://download.libguestfs.org/guestfs-tools/${lib.versions.majorMinor version}-stable/guestfs-tools-${version}.tar.gz";
    sha256 = "sha256-rH/MK9Xid+lb1bKnspCE3gATefBnHDZAQ3NRavhTvLA=";
=======
  version = "1.48.2";

  src = fetchurl {
    url = "https://download.libguestfs.org/guestfs-tools/${lib.versions.majorMinor version}-stable/guestfs-tools-${version}.tar.gz";
    sha256 = "sha256-G9l5sG5g5kMlSXzg0GX8+Et7M9/k2dRLMBgsMI4MaxA=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    bash-completion
<<<<<<< HEAD
    glib
    hivex
    jansson
    libguestfs-with-appliance
    libosinfo
=======
    hivex
    jansson
    libguestfs-with-appliance
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    libvirt
    libxml2
    ncurses
    openssl
    pcre2
    xz
  ];

  postPatch = ''
    # If it uses the executable name, then there's nothing we can do
    # when wrapping to stop it looking in
    # $out/etc/.virt-builder-wrapped, which won't exist.
    substituteInPlace common/mlstdutils/std_utils.ml \
        --replace Sys.executable_name '(Array.get Sys.argv 0)'
  '';

  preConfigure = ''
    patchShebangs ocaml-dep.sh.in ocaml-link.sh.in run.in
  '';

  makeFlags = [
    "LIBGUESTFS_PATH=${libguestfs-with-appliance}/lib/guestfs"
  ];

  installFlags = [
    "BASH_COMPLETIONS_DIR=${placeholder "out"}/share/bash-completion/completions"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    wrapProgram $out/bin/virt-builder \
      --argv0 virt-builder \
      --prefix PATH : ${lib.makeBinPath [ curl gnupg ]}:$out/bin \
      --suffix VIRT_BUILDER_DIRS : /etc:$out/etc
    wrapProgram $out/bin/virt-win-reg \
      --prefix PERL5LIB : ${with perlPackages; makeFullPerlPath [ hivex libintl-perl libguestfs-with-appliance ]}
  '';

  meta = with lib; {
    description = "Extra tools for accessing and modifying virtual machine disk images";
    license = with licenses; [ gpl2Plus lgpl21Plus ];
    homepage = "https://libguestfs.org/";
    maintainers = with maintainers; [ thiagokokada ];
    platforms = platforms.linux;
  };
}
