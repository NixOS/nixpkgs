{ stdenv, kernel, perl }:

stdenv.mkDerivation {
  name = "linux-headers-${kernel.version}";

  inherit (stdenv.platform) kernelArch;

  nativeBuildInputs = [ perl ];

  crossAttrs = {
    inherit (stdenv.cross.platform) kernelArch;
  };

  buildCommand = ''
    make -C ${kernel.sourceRoot} ARCH=$kernelArch INSTALL_HDR_PATH=$out O=$PWD headers_install
    find $out \( -name ..install.cmd -o -name .install \) -print0 | xargs -0 rm
  '';

  # Headers shouldn't reference anything else
  allowedReferences = [];
}
