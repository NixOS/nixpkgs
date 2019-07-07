{ stdenv, gcc, libav_12, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "untrunc-${version}";
  version = "2018.01.13";

  src = fetchFromGitHub {
    owner = "ponchio";
    repo = "untrunc";
    rev = "3a2e6d0718faf06589f7b9d95c8f966348e537f7";
    sha256 = "03ka4lr69k7mikfpcpd95smzdj62v851ididnjyps5a0j06f8087";
  };

  buildInputs = [ gcc libav_12 ];

  # Untrunc uses the internal libav headers 'h264dec.h' and 'config.h'.
  # The latter must be created through 'configure'.
  libavConfiguredSrc = libav_12.overrideAttrs (oldAttrs: {
    name = "libav-configured-src";
    outputs = [ "out" ];
    phases = [ "unpackPhase" "patchPhase" "configurePhase" "installPhase" ];
    installPhase = "cp -r . $out";
  });

  buildCommand = ''
    mkdir -p $out/bin
    g++ -o $out/bin/untrunc \
        -Wno-deprecated-declarations \
        $src/file.cpp $src/main.cpp $src/track.cpp $src/atom.cpp $src/mp4.cpp \
        -I$libavConfiguredSrc -lavformat -lavcodec -lavutil
  '';

  meta = with stdenv.lib; {
    description = "Restore a damaged (truncated) mp4, m4v, mov, 3gp video from a similar, undamaged video";
    license = licenses.gpl2;
    homepage = https://github.com/ponchio/untrunc;
    maintainers = [ maintainers.earvstedt ];
  };
}
