{ stdenv, kernel, perl, gmp, libmpc, mpfr, bc }:

let
  baseBuildFlags = [ "INSTALL_HDR_PATH=$(out)" "headers_install" ];
in stdenv.mkDerivation {
  name = "linux-headers-${kernel.version}";

  inherit (kernel) src patches;

  nativeBuildInputs = [ perl ]
    ++ stdenv.lib.optionals (kernel.features.grsecurity or false) [ gmp libmpc mpfr bc ];

  preConfigure = stdenv.lib.optionals (kernel.features.grsecurity or false) ''
    cp ${kernel.configfile} .config
    make prepare
  '';

  buildFlags = [ "ARCH=${stdenv.platform.kernelArch}" ] ++ baseBuildFlags;

  crossAttrs = {
    inherit (kernel.crossDrv) src patches;
    buildFlags = [ "ARCH=${stdenv.cross.platform.kernelArch}" ] ++ baseBuildFlags;
  };

  installPhase = ''
    find $out \( -name ..install.cmd -o -name .install \) -print0 | xargs -0 rm
  '';

  # Headers shouldn't reference anything else
  allowedReferences = [];

  meta.platforms = stdenv.lib.platforms.linux;
}
