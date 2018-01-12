{ stdenv, fetchFromGitHub, premake5, ninja, hostPlatform }:

stdenv.mkDerivation rec {
  name = "otfcc-${version}";
  version = "0.8.6";

  src = fetchFromGitHub {
    owner = "caryll";
    repo = "otfcc";
    rev = "v${version}";
    sha256 = "0yy9awffxxs0cdlf0akld73ndnwmylxvplac4k6j7641m3vk1g8p";
  };

  nativeBuildInputs = [ premake5 ninja ];

  configurePhase = ''
    premake5 ninja
  '';

  ninjaFlags = let x = if hostPlatform.isi686 then "x86" else "x64"; in
    [ "-C" "build/ninja" "otfccdump_release_${x}" "otfccbuild_release_${x}" ];

  installPhase = ''
    mkdir -p $out/bin
    cp bin/release-x*/otfcc* $out/bin/
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Optimized OpenType builder and inspector";
    homepage = https://github.com/caryll/otfcc;
    license = licenses.asl20;
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ jfrankenau ttuegel ];
  };

}
