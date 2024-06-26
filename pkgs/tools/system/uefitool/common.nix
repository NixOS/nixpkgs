{
  version,
  sha256,
  installFiles,
}:
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
  passthru = {
    inherit version;
    inherit sha256;
    inherit installFiles;
  };
  pname = "uefitool";
  inherit version;

  src = fetchFromGitHub {
    inherit sha256;
    owner = "LongSoft";
    repo = pname;
    rev = version;
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
    cp ${lib.concatStringsSep " " installFiles} "$out"/bin
  '';

  meta = with lib; {
    description = "UEFI firmware image viewer and editor";
    homepage = "https://github.com/LongSoft/uefitool";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
    # uefitool supposedly works on other platforms, but their build script only works on linux in nixpkgs
    platforms = platforms.linux;
  };
}
