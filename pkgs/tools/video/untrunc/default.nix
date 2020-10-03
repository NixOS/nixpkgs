{ stdenv, gcc, libav_12, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "untrunc";
  version = "2020.02.09";

  src = fetchFromGitHub {
    owner = "ponchio";
    repo = "untrunc";
    rev = "4eed44283168c727ace839ff7590092fda2e0848";
    sha256 = "0nfj67drc6bxqlkf8a1iazqhi0w38a7rjrb2bpa74gwq6xzygvbr";
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
    homepage = "https://github.com/ponchio/untrunc";
    maintainers = [ maintainers.earvstedt ];
  };
}
