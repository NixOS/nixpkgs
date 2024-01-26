{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "betterdiscordctl";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "bb010g";
    repo = "betterdiscordctl";
    rev = "v${version}";
    sha256 = "0p321rfcihz2779sdd6qfgpxgk5yd53d33vq5pvb50dbdgxww0bc";
  };

  postPatch = ''
    substituteInPlace betterdiscordctl \
      --replace "DISABLE_SELF_UPGRADE=" "DISABLE_SELF_UPGRADE=yes"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/share/doc/betterdiscordctl"
    install -Dm744 betterdiscordctl $out/bin/betterdiscordctl
    install -Dm644 README.md $out/share/doc/betterdiscordctl/README.md

    runHook postInstall
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/betterdiscordctl --version
  '';

  meta = with lib; {
    homepage = "https://github.com/bb010g/betterdiscordctl";
    description = "A utility for managing BetterDiscord on Linux";
    license = licenses.mit;
    mainProgram = "betterdiscordctl";
    maintainers = with maintainers; [ ivar bb010g ];
    platforms = platforms.linux;
  };
}
