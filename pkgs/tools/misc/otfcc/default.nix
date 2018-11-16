{ stdenv, fetchFromGitHub, premake5, ninja }:

stdenv.mkDerivation rec {
  name = "otfcc-${version}";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "caryll";
    repo = "otfcc";
    rev = "v${version}";
    sha256 = "1rnjfqqyc6d9nhlh8if9k37wk94mcwz4wf3k239v6idg48nrk10b";
  };

  nativeBuildInputs = [ premake5 ninja ];

  configurePhase = ''
    premake5 ninja
  '';

  ninjaFlags = let x = if stdenv.hostPlatform.isi686 then "x86" else "x64"; in
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
