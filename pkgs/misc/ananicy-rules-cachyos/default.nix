{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "ananicy";
  version = "unstable-2023-06-28";

  src = fetchFromGitHub {
    owner = "CachyOS";
    repo = "ananicy-rules";
    rev = "b2b4342d769bc3c6abc4ce77bd53d6ca06d659e5";
    sha256 = "sha256-TGX7GlfSeKu68mVM71/kdJH31gzMmhzCAqA390aEq8U=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preBuild
    mkdir -p $out
    cp -r * $out
    rm $out/README.md
    runHook postBuild
  '';

  meta = with lib; {
    homepage = "https://github.com/CachyOS/ananicy-rules";
    description = "ananicy-cpp-rules for CachyOS ";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ artturin ];
  };
}
