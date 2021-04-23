{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "betterdiscordctl";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "bb010g";
    repo = "betterdiscordctl";
    rev = "v${version}";
    sha256 = "12c3phcfwl4p2jfh22ihm57vxw4nq5kwqirb7y4gzc91swfh5yj1";
  };

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
