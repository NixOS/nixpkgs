{ stdenv, fetchFromGitHub, cmake, SDL2, libGLU, luajit, curl, curlpp }:

let
  # Newer versions of sdl-gpu don't work with Riko4 (corrupted graphics),
  # and this library does not have a proper release version, so let the
  # derivation for this stay next to the Riko4 derivation for now.
  sdl-gpu = stdenv.mkDerivation rec {
    name = "sdl-gpu-${version}";
    version = "2018-11-01";
    src = fetchFromGitHub {
      owner = "grimfang4";
      repo = "sdl-gpu";
      rev = "a4ff1ab02410f154b004c29ec46e07b22890fa1f";
      sha256 = "1wdwg331s7r4dhq1l8w4dvlqf4iywskpdrscgbwrz9j0c6nqqi3v";
    };
    buildInputs = [ SDL2 libGLU ];
    nativeBuildInputs = [ cmake ];
    enableParallelBuilding = true;

    meta = with stdenv.lib; {
      homepage = https://github.com/grimfang4/sdl-gpu;
      description = "A library for high-performance, modern 2D graphics with SDL written in C";
      license = licenses.mit;
      maintainers = with maintainers; [ CrazedProgrammer ];
    };
  };
in

stdenv.mkDerivation rec {
  name = "riko4-${version}";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "incinirate";
    repo = "Riko4";
    rev = "v${version}";
    sha256 = "008i9991sn616dji96jfwq6gszrspbx4x7cynxb1cjw66phyy5zp";
  };

  buildInputs = [ SDL2 luajit sdl-gpu curl curlpp ];
  nativeBuildInputs = [ cmake ];

  hardeningDisable = [ "fortify" ];
  cmakeFlags = [ "-DSDL2_gpu_INCLUDE_DIR=\"${sdl-gpu}/include\"" ];

  # Riko4 needs the data/ and scripts/ directories to be in its PWD.
  installPhase = ''
    install -Dm0755 riko4 $out/bin/.riko4-unwrapped
    mkdir -p $out/lib/riko4
    cp -r ../data $out/lib/riko4
    cp -r ../scripts $out/lib/riko4
    cat > $out/bin/riko4 <<EOF
    #!/bin/sh
    pushd $out/lib/riko4 > /dev/null
    exec $out/bin/.riko4-unwrapped "\$@"
    popd > /dev/null
    EOF
    chmod +x $out/bin/riko4
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/incinirate/Riko4;
    description = "Fantasy console for pixel art game development";
    license = licenses.mit;
    maintainers = with maintainers; [ CrazedProgrammer ];
  };
}
