{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "betterdiscordctl";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "bb010g";
    repo = "betterdiscordctl";
    rev = "v${version}";
    sha256 = "1wys3wbcz5hq8275ia2887kr5fzz4b3gkcp56667j9k0p3k3zfac";
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

  meta = with lib; {
    homepage = "https://github.com/bb010g/betterdiscordctl";
    description = "A utility for managing BetterDiscord on Linux";
    license = licenses.mit;
    maintainers = with maintainers; [ ivar bb010g ];
    platforms = platforms.linux;
  };
}
