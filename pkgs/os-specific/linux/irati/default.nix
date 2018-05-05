{ stdenv, fetchFromGitHub, libssl, zlib, protobuf, pkgconfig
, python3, kmod
, autoconf, automake, libtool }:

with (import ./srcs.nix { inherit stdenv fetchFromGitHub; });

rec {
  librina = stdenv.mkDerivation {
    name = "librina-${version}";
    inherit src version prePatch meta;

    buildInputs = [
      libssl zlib protobuf pkgconfig
      autoconf automake libtool # for the preConfigure phase
    ];

    configurePhase = ''
      sed -i 's=make clean install=exit 0=' configure
      sed -i 's=.*Starting rinad.*=exit 0=' configure

      # Generate the main Makefile
      ./configure --prefix $out --kernbuilddir .
    '';

    buildPhase = ''
      cd build/librina
      make clean install
    '';
  };

  rinad = stdenv.mkDerivation {
    name = "rinad-${version}";
    inherit src version prePatch meta;
    postPatch = ''
      sed -i 's|execlp("modprobe"|execlp("${kmod}/bin/modprobe"|g' rinad/src/ipcm/ipcm.cc
    '';

    outputs = [ "bin" "lib" "dev" "out" ];

    buildInputs = [
      librina
      libssl zlib protobuf pkgconfig
      autoconf automake libtool # for the preConfigure phase
    ];

    preConfigure = ''
      cd rinad
      ./bootstrap
    '';
    configureFlags = [ "--disable-java-bindings" ];
  };

  rina-tools = stdenv.mkDerivation {
    name = "rina-tools-${version}";
    inherit src version prePatch meta;

    buildInputs = [
      librina rinad
      libssl zlib protobuf pkgconfig
      autoconf automake libtool # for the preConfigure phase
      python3  # for irati-ctl
    ];

    # code won't build with -Werror=maybe-uninitialized
    NIX_CFLAGS_COMPILE = "-w";

    preConfigure = ''
      cd rina-tools
      ./bootstrap
    '';
  };
}
