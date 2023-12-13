nvidia_x11: sha256:

{ stdenv
, lib
, fetchFromGitHub
, m4
, libtirpc
}:

stdenv.mkDerivation rec {
  pname = "nvidia-persistenced";
  version = nvidia_x11.persistencedVersion;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvidia-persistenced";
    rev = nvidia_x11.persistencedVersion;
    inherit sha256;
  };

  nativeBuildInputs = [ m4 ];
  buildInputs = [ libtirpc ];

  inherit (nvidia_x11) makeFlags;

  installFlags = [ "PREFIX=$(out)" ];

  postFixup = ''
    # Save a copy of persistenced for mounting in containers
    mkdir $out/origBin
    cp $out/{bin,origBin}/nvidia-persistenced
    patchelf --set-interpreter /lib64/ld-linux-x86-64.so.2 $out/origBin/nvidia-persistenced

    patchelf --set-rpath "$(patchelf --print-rpath $out/bin/nvidia-persistenced):${nvidia_x11}/lib" \
      $out/bin/nvidia-persistenced
  '';

  env.NIX_CFLAGS_COMPILE = toString [ "-I${libtirpc.dev}/include/tirpc" ];
  NIX_LDFLAGS = [ "-ltirpc" ];

  meta = with lib; {
    homepage = "https://www.nvidia.com/object/unix.html";
    description = "Settings application for NVIDIA graphics cards";
    license = licenses.unfreeRedistributable;
    platforms = nvidia_x11.meta.platforms;
    maintainers = with maintainers; [ abbradar ];
    mainProgram = pname;
  };
}
