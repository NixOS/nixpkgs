{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "ananicy";
  version = "unstable-2023-10-11";

  src = fetchFromGitHub {
    owner = "CachyOS";
    repo = "ananicy-rules";
    rev = "3dafc3eb667b6ed7024359de78bf961c7248954d";
    sha256 = "sha256-bMwM/2R6jdgrQ6C0JnHyMp9L4OWI6KVGcninrr7wLQ8=";
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
