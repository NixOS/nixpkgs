{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "hacpack";
  version = "1.36";

  src = fetchFromGitHub {
    owner = "The-4n";
    repo = "hacpack";
    rev = "v${version}";
    sha256 = "0d846l36w1n9rxv79fbyhl2zdbqhlgrvk21b9vzr9x77yki89ygs";
  };

  preConfigure = ''
    mv config.mk.template config.mk
  '';

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];
  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/bin
    cp ./hacpack $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/The-4n/hacPack";
    description = "Make and repack Nintendo Switch NCAs/NSPs";
    license = licenses.gpl2Only;
    maintainers = [ ];
    platforms = platforms.linux;
    mainProgram = "hacpack";
  };
}
