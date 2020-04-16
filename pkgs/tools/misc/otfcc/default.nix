{ stdenv, fetchFromGitHub, premake5 }:

stdenv.mkDerivation rec {
  pname = "otfcc";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "caryll";
    repo = "otfcc";
    rev = "v${version}";
    sha256 = "1nrkzpqklfpqsccji4ans40rj88l80cv7dpxwx4g577xrvk13a0f";
  };

  nativeBuildInputs = [ premake5 ];

  # Don’t guess where our makefiles will end up. Just use current
  # directory.
  patchPhase = ''
    substituteInPlace premake5.lua \
      --replace 'location "build/gmake"' 'location "."'
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/release-x*/otfcc* $out/bin/
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Optimized OpenType builder and inspector";
    homepage = "https://github.com/caryll/otfcc";
    license = licenses.asl20;
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ jfrankenau ttuegel ];
  };

}
