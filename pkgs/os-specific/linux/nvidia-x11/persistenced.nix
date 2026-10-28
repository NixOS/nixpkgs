nvidia_x11: sha256:

{
  stdenv,
  lib,
  fetchFromGitHub,
  buildPackages,
  m4,
  pkg-config,
  addDriverRunpath,
  libtirpc,
}:

stdenv.mkDerivation {
  pname = "nvidia-persistenced";
  version = nvidia_x11.persistencedVersion;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvidia-persistenced";
    rev = nvidia_x11.persistencedVersion;
    inherit sha256;
  };

  env = lib.optionalAttrs (lib.versionOlder nvidia_x11.persistencedVersion "450.51") {
    NIX_CFLAGS_COMPILE = toString [ "-I${libtirpc.dev}/include/tirpc" ];
    NIX_LDFLAGS = toString [ "-ltirpc" ];
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [
    m4
    pkg-config
    addDriverRunpath
  ];

  buildInputs = [
    libtirpc
  ];

  makeFlags = [
    "DATE=true"
    "DO_STRIP="
    "HOST_CC=\$(CC_FOR_BUILD)"
    "HOST_LD=\$(LD_FOR_BUILD)"
  ];

  installFlags = [ "PREFIX=$(out)" ];

  postFixup = ''
    # Save a copy of persistenced for mounting in containers
    mkdir $out/origBin
    cp $out/{bin,origBin}/nvidia-persistenced
    patchelf --set-interpreter /lib64/ld-linux-x86-64.so.2 $out/origBin/nvidia-persistenced

    addDriverRunpath $out/bin/nvidia-persistenced
  '';

  meta = {
    homepage = "https://github.com/NVIDIA/nvidia-persistenced";
    description = "NVIDIA driver persistence daemon";
    license = lib.licenses.mit;
    platforms = nvidia_x11.meta.platforms;
    maintainers = [ ];
    mainProgram = "nvidia-persistenced";
  };
}
