{ stdenv, kernel, perl, libmpc }:

let
  baseBuildFlags = [ "INSTALL_HDR_PATH=$(out)" "headers_install" ];
in stdenv.mkDerivation {
  name = "linux-headers-${kernel.version}";

  inherit (kernel) src patches;

  nativeBuildInputs = [ perl libmpc ];

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
}
