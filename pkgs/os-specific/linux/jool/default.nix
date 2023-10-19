{ lib, stdenv, fetchFromGitHub, kernel, nixosTests }:

let
  sourceAttrs = (import ./source.nix) { inherit fetchFromGitHub; };
in

stdenv.mkDerivation {
  name = "jool-${sourceAttrs.version}-${kernel.version}";

  src = sourceAttrs.src;

  nativeBuildInputs = kernel.moduleBuildDependencies;
  hardeningDisable = [ "pic" ];

  prePatch = ''
    sed -e 's@/lib/modules/\$(.*)@${kernel.dev}/lib/modules/${kernel.modDirVersion}@' -i src/mod/*/Makefile
  '';

  makeFlags = kernel.makeFlags ++ [
    "-C src/mod"
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];

  installTargets = "modules_install";

  passthru.tests = { inherit (nixosTests) jool; };

  meta = with lib; {
    homepage = "https://www.jool.mx/";
    description = "Fairly compliant SIIT and Stateful NAT64 for Linux - kernel modules";
    platforms = platforms.linux;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fpletz ];
  };
}
