<<<<<<< HEAD
{ lib, stdenvNoCC, fetchFromGitHub, makeWrapper, curl, jq, coreutils, file }:

stdenvNoCC.mkDerivation rec {
  pname = "discord-sh";
  version = "2.0.0";
=======
{ lib, stdenvNoCC, fetchFromGitHub, makeWrapper, curl, jq, coreutils }:

stdenvNoCC.mkDerivation {
  pname = "discord-sh";
  version = "unstable-2022-05-19";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ChaoticWeg";
    repo = "discord.sh";
<<<<<<< HEAD
    rev = "v${version}";
    sha256 = "sha256-ZOGhwR9xFzkm+q0Gm8mSXZ9toXG4xGPNwBQMCVanCbY=";
=======
    rev = "6aaea548f88eb48b7adeef824fbddac1c4749447";
    sha256 = "sha256-RoPhn/Ot4ID1nEbZEz1bd2iq8g7mU2e7kwNRvZOD/pc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # ignore Makefile by disabling buildPhase. Upstream Makefile tries to download
  # binaries from the internet for linting
  dontBuild = true;

  # discord.sh looks for the .webhook file in the source code directory, which
  # isn't mutable on Nix
  postPatch = ''
    substituteInPlace discord.sh \
      --replace 'thisdir="$(cd "$(dirname "$(readlink -f "''${BASH_SOURCE[0]}")")" && pwd)"' 'thisdir="$(pwd)"'
  '';

  nativeBuildInputs = [ makeWrapper ];

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preCheck
    $out/bin/discord.sh --help
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    install -Dm555 discord.sh $out/bin/discord.sh
    wrapProgram $out/bin/discord.sh \
<<<<<<< HEAD
      --set PATH "${lib.makeBinPath [ curl jq coreutils file ]}"
=======
      --set PATH "${lib.makeBinPath [ curl jq coreutils ]}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    runHook postInstall
  '';

  meta = with lib; {
    description = "Write-only command-line Discord webhook integration written in 100% Bash script";
    homepage = "https://github.com/ChaoticWeg/discord.sh";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}
