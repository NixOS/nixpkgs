{
  lib,
  mkDerivation,
  fetchFromGitHub,
  qtbase,
  qmake,
  cmake,
  zip,
}:

mkDerivation rec {
  pname = "uefitool";
  version = "0.28.0";

  src = fetchFromGitHub {
    hash = "sha256-StqrOMsKst2X2yQQ/Xl7iLAuA4QXEOyj2KtE7ZtoUNg=";
    owner = "LongSoft";
    repo = "uefitool";
    tag = version;
  };

  buildInputs = [ qtbase ];
  nativeBuildInputs = [
    qmake
    cmake
    zip
  ];

  dontConfigure = true;
  buildPhase = ''
    bash unixbuild.sh
  '';

  installPhase = ''
    mkdir -p "$out"/bin
    cp UEFITool UEFIReplace/UEFIReplace UEFIPatch/UEFIPatch "$out"/bin
  '';

  meta = {
    description = "UEFI firmware image viewer and editor";
    homepage = "https://github.com/LongSoft/uefitool";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ athre0z ];
    # uefitool supposedly works on other platforms, but their build script only works on linux in nixpkgs
    platforms = lib.platforms.linux;
    mainProgram = "UEFITool";
  };
}
