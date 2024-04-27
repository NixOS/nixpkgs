{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname = "ananicy-rules-cachyos";
  version = "unstable-2024-04-22";

  src = fetchFromGitHub {
    owner = "CachyOS";
    repo = "ananicy-rules";
    rev = "8646faa8c0c8fc16d78ca3a25d65ddbd86b9d468";
    hash = "sha256-b9M6Uqlb6Ysp8BRe1QV62sjVOU6tgFbrjTxDc3B4xlg=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/etc/ananicy.d
    rm README.md LICENSE
    cp -r * $out/etc/ananicy.d
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/CachyOS/ananicy-rules";
    description = "CachyOS' ananicy-rules meant to be used with ananicy-cpp";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ artturin johnrtitor diniamo ];
  };
}
