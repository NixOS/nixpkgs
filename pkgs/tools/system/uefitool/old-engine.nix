{ lib, mkDerivation, fetchFromGitHub, qtbase, qmake, cmake, zip }:

mkDerivation rec {
  pname = "uefitool";
  version = "0.28.0";

  src = fetchFromGitHub {
    sha256 = "1n2hd2dysi5bv2iyq40phh1jxc48gdwzs414vfbxvcharcwapnja";
    owner = "LongSoft";
    repo = pname;
    rev = version;
  };

  buildInputs = [ qtbase ];
  nativeBuildInputs = [ qmake cmake zip ];

  dontConfigure = true;
  buildPhase = ''
    bash unixbuild.sh
  '';

  installPhase = ''
    mkdir -p "$out"/bin
    cp UEFITool UEFIReplace/UEFIReplace UEFIPatch/UEFIPatch "$out"/bin
  '';

  meta = with lib; {
    description = "UEFI firmware image viewer and editor";
    homepage = "https://github.com/LongSoft/uefitool";
    license = licenses.bsd2;
    maintainers = with maintainers; [ athre0z ];
    # uefitool supposedly works on other platforms, but their build script only works on linux in nixpkgs
    platforms = platforms.linux;
    mainProgram = "UEFITool";
  };
}
