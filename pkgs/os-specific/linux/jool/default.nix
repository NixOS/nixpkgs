{ lib, stdenv, fetchFromGitHub, fetchpatch, kernel }:

let
  sourceAttrs = (import ./source.nix) { inherit fetchFromGitHub; };
in

stdenv.mkDerivation {
  name = "jool-${sourceAttrs.version}-${kernel.version}";

  src = sourceAttrs.src;

  nativeBuildInputs = kernel.moduleBuildDependencies;
  hardeningDisable = [ "pic" ];

  patches = [
    (fetchpatch {
      url = "https://git.launchpad.net/ubuntu/+source/jool/plain/debian/patches/0001-Linux-6.2.patch?id=3708a5b6c492b7d8e9f78596e61ae8f74ec9640f";
      hash = "sha256-GkyDY6tcJp7Xd28mrDorEJHxsEowZBJP7BRAdPpsyF8=";
    })
  ];

  prePatch = ''
    sed -e 's@/lib/modules/\$(.*)@${kernel.dev}/lib/modules/${kernel.modDirVersion}@' -i src/mod/*/Makefile
  '';

  makeFlags = kernel.makeFlags ++ [
    "-C src/mod"
    "INSTALL_MOD_PATH=${placeholder "out"}"
  ];

  installTargets = "modules_install";

  meta = with lib; {
    homepage = "https://www.jool.mx/";
    description = "Fairly compliant SIIT and Stateful NAT64 for Linux - kernel modules";
    platforms = platforms.linux;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fpletz ];
  };
}
