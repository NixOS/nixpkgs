{ stdenv, fetchzip, kernel }:

assert stdenv.lib.versionOlder kernel.version "4.10";

let
  sourceAttrs = (import ./source.nix) { inherit fetchzip; };
in

stdenv.mkDerivation {
  name = "jool-${sourceAttrs.version}-${kernel.version}";

  src = sourceAttrs.src;

  hardeningDisable = [ "pic" ];

  prePatch = ''
    sed -e 's@/lib/modules/\$(.*)@${kernel.dev}/lib/modules/${kernel.modDirVersion}@' -i mod/*/Makefile
  '';

  buildPhase = ''
    make -C mod
  '';

  installPhase = ''
    make -C mod modules_install INSTALL_MOD_PATH=$out
  '';

  meta = with stdenv.lib; {
    homepage = https://www.jool.mx/;
    description = "Fairly compliant SIIT and Stateful NAT64 for Linux - kernel modules";
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
  };
}
