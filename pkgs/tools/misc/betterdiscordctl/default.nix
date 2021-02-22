{ lib, stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "betterdiscordctl";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "bb010g";
    repo = "betterdiscordctl";
    rev = "v${version}";
    sha256 = "0qpmm5l8jhm7k0kqblc0bnr9fl4b6z8iddhjar03bb4kqgr962fa";
  };

  patches = [
    (fetchpatch { # Required till https://github.com/bb010g/betterdiscordctl/pull/67 is merged upstream.
      url = "https://github.com/bb010g/betterdiscordctl/pull/67/commits/f1c7170fc2626d9aec4d244977b5a73c401aa1d4.patch";
      sha256 = "003zqd9ljb9h674sjwjvvdfs7q4cw0p1ydg3lax132vb4vz9k0zi";
    })
  ];

  preBuild = "sed -i 's/^nix=$/&yes/g;s/^DISABLE_UPGRADE=$/&yes/g' ./betterdiscordctl";

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/doc/betterdiscordctl
    install -Dm744 betterdiscordctl $out/bin/betterdiscordctl
    install -Dm644 README.md $out/share/doc/betterdiscordctl/README.md
  '';

  meta = with lib; {
    homepage = "https://github.com/bb010g/betterdiscordctl";
    description = "A utility for managing BetterDiscord on Linux";
    license = licenses.mit;
    maintainers = with maintainers; [ ivar bb010g ];
    platforms = platforms.linux;
  };
}
