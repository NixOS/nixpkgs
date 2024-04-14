{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "ananicy-rules-cachyos";
  version = "unstable-2024-04-10";

  src = fetchFromGitHub {
    owner = "CachyOS";
    repo = "ananicy-rules";
    rev = "de55e2f55e6adf559bf4990aa433f5c202dc073d";
    sha256 = "sha256-TWaOMVEeTLI67eG5BPyb+OSnz31QvTueQD2yfEEbTEo=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r * $out
    rm $out/README.md
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/CachyOS/ananicy-rules";
    description = "ananicy-cpp-rules for CachyOS ";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ artturin johnrtitor diniamo ];
  };
}
