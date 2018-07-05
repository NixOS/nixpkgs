{ stdenv, fetchFromGitHub, kernel }:

with (import ./srcs.nix { inherit stdenv fetchFromGitHub; });

stdenv.mkDerivation {
  name = "rlite-${version}-${kernel.version}";
  inherit version src prePatch meta;

  nativeBuildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  configurePhase = ''
    ${stdenv.shell} ./configure --no-user --prefix $out \
        --kernbuilddir ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build
  '';
  buildPhase = "make ker";
  installPhase = "make ker_install";
}
