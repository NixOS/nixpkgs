nvidia_x11: sha256:

{
  stdenv,
  lib,
  fetchFromGitHub,
  m4,
  glibc,
  libtirpc,
  pkg-config,
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

  env = {
    LIBRARY_PATH = "${glibc}/lib";
    NIX_CFLAGS_COMPILE = toString [ "-I${libtirpc.dev}/include/tirpc" ];
  };
  NIX_LDFLAGS = [ "-ltirpc" ];

  nativeBuildInputs = [
    m4
    pkg-config
  ];

  buildInputs = [
    libtirpc
    stdenv.cc.cc.lib
  ];

  makeFlags = nvidia_x11.makeFlags ++ [ "DATE=true" ];

  installFlags = [ "PREFIX=$(out)" ];

  postFixup = ''
    # Save a copy of persistenced for mounting in containers
    mkdir $out/origBin
    cp $out/{bin,origBin}/nvidia-persistenced
    patchelf --set-interpreter /lib64/ld-linux-x86-64.so.2 $out/origBin/nvidia-persistenced

    patchelf --set-rpath "$(patchelf --print-rpath $out/bin/nvidia-persistenced):${nvidia_x11}/lib" \
      $out/bin/nvidia-persistenced
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
