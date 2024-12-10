{
  lib,
  stdenv,
  fetchFromGitHub,
  premake5,
}:

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

  patches = [
    ./fix-aarch64.patch
    ./move-makefiles.patch
  ];

  buildFlags = lib.optionals stdenv.isAarch64 [ "config=release_arm" ];

  installPhase = ''
    mkdir -p $out/bin
    cp bin/release-*/otfcc* $out/bin/
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Optimized OpenType builder and inspector";
    homepage = "https://github.com/caryll/otfcc";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ttuegel ];
  };

}
