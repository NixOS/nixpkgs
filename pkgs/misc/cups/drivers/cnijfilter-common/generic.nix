# Based on: https://github.com/tokiclover/bar-overlay/blob/ddd118f571a63160c0517e7108aefcbba79d969e/eclass/ecnij.eclass
# With the following license:
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Original author: tokiclover <tokiclover@gmail.com>

{
  stdenv,
  autoconf,
  automake,
  libtool,
  glib,
}:
printers: { version, src, ... }@args:
stdenv.mkDerivation ({
  pname = "cnijfilter";
  nativeBuildInputs = [
    autoconf
    automake
    libtool
    glib.dev
  ];

  configurePhase = ''
    runHook preConfigure
    source ${./ecnij.sh}
    PRINTER_ID=(${stdenv.lib.escapeShellArgs (map (printer: printer.id) printers)})
    PRINTER_MODEL=(${stdenv.lib.escapeShellArgs (map (printer: printer.model) printers)})
    ecnij_pkg_setup
    ecnij_src_prepare
    ecnij_src_configure
    runHook postConfigure
  '';

  abi_lib =
    if stdenv.targetPlatform.isx86_64 then "64"
      else if stdenv.isx86_32 then "32"
      else throw "Unsupported target!";

  # TODO: for development, remove later
  shellHook = ''
    export out=/tmp/canon-install
    source ${./ecnij.sh}
    PRINTER_ID=(${stdenv.lib.escapeShellArgs (map (printer: printer.id) printers)})
    PRINTER_MODEL=(${stdenv.lib.escapeShellArgs (map (printer: printer.model) printers)})
    ecnij_pkg_setup
  '';

  buildPhase = ''
    runHook preBuild
    ecnij_src_compile
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    ecnij_src_install
    ecnij_pkg_postinst
    runHook postInstall
  '';

  passthru = {
    inherit printers;
  };
} // args)