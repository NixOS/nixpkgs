{ lib
, stdenv
, fetchurl
, autoreconfHook
, bison
, cdrkit
, cpio
, flex
, getopt
, makeWrapper
, pkg-config
, qemu
, ocamlPackages
, perlPackages
, bash-completion
, jansson
, libvirt
, libxcrypt
, libxml2
, ncurses
, pcre2
, xz
, hivex
, libguestfs
, guestfs-tools
, callPackage
, appliance ? null
}:

assert appliance == null || lib.isDerivation appliance;

stdenv.mkDerivation rec {
  pname = "guestfs-tools";
  version = "1.48.2";

  src = fetchurl {
    url = "https://download.libguestfs.org/${pname}/${lib.versions.majorMinor version}-stable/${pname}-${version}.tar.gz";
    sha256 = "sha256-G9l5sG5g5kMlSXzg0GX8+Et7M9/k2dRLMBgsMI4MaxA=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    autoreconfHook
    bison
    cdrkit
    cpio
    flex
    getopt
    hivex
    makeWrapper
    pkg-config
    qemu
    perlPackages.perl
  ] ++ (with ocamlPackages; [
    ocaml
    ocamlbuild
    findlib
    gettext-stub
  ]);

  buildInputs = [
    bash-completion
    hivex
    jansson
    libvirt
    libxcrypt
    libxml2
    ncurses
    pcre2
    xz
    perlPackages.perl
  ] ++ (with ocamlPackages; [
    gettext-stub
    ounit2
  ]);

  propagatedBuildInputs = [
    hivex
    (libguestfs.override { inherit appliance; })
  ] ++ (with perlPackages; [
    libintl-perl
    ModuleBuild
  ]);

  postPatch = ''
    for file in {*.sh.in,run.in}; do
      substituteInPlace "$file" --replace '#!/bin/bash' '#!${stdenv.shell}'
    done

    patchShebangs .
  '';

  makeFlags = [
    "BASH_COMPLETIONS_DIR=${placeholder "out"}/share/bash-completion/completions"
  ];

  postInstall = ''
    wrapProgram $out/bin/virt-win-reg \
      --prefix PERL5LIB : "$PERL5LIB"
  '';

  passthru.tests = callPackage ./tests.nix {
    libguestfs = libguestfs.override { inherit appliance; };
    guestfs-tools = guestfs-tools.override { inherit appliance; };
  };

  meta = with lib; {
    description = "Tools for accessing and modifying guest disk images.";
    license = with licenses; [ gpl2Plus lgpl21Plus ];
    homepage = "https://libguestfs.org/";
    maintainers = with maintainers; [ twz123 ];
    platforms = platforms.linux;
    # this is to avoid "output size exceeded"
    hydraPlatforms = if appliance != null then appliance.meta.hydraPlatforms else platforms.linux;
  };
}
