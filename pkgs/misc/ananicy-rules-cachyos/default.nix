{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation {
  pname = "ananicy-rules-cachyos";
  version = "unstable-2024-04-16";

  src = fetchFromGitHub {
    owner = "CachyOS";
    repo = "ananicy-rules";
    rev = "7abaddd5cac23d9fd7a0f0aeccb7a0287456802b";
    hash = "sha256-06q9dYLdg+AhT8L2OeoDsG7hHlmx/uf/RIwblODiSnE=";
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

  meta = with lib; {
    homepage = "https://github.com/CachyOS/ananicy-rules";
    description = "CachyOS' ananicy-rules meant to be used with ananicy-cpp";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ artturin johnrtitor diniamo ];
  };
}
