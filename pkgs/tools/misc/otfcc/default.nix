{ stdenv, fetchurl, premake5, hostPlatform }:

stdenv.mkDerivation rec {
  name = "otfcc-${version}";
  version = "0.8.6";

  src = fetchurl {
    url = "https://github.com/caryll/otfcc/archive/v${version}.tar.gz";
    sha256 = "0kap52bzrn21fmph8j2pc71f80f38ak1p2fcczzmrh0hb1r9c8dd";
  };

  nativeBuildInputs = [ premake5 ];

  configurePhase = ''
    premake5 gmake
  '';

  preBuild = "cd build/gmake";

  makeFlags = ''config=release_${if hostPlatform.isi686 then "x86" else "x64"}'';

  postBuild = "cd ../..";

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
