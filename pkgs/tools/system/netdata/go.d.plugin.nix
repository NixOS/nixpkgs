{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "netdata-go.d.plugin";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "netdata";
    repo = "go.d.plugin";
    rev = "v${version}";
    sha256 = "0v732mndhgrbqiwsdndqd08pvgbvl4ffn5rqbyv7iw1dwwr08f67";
  };

  goPackagePath = "github.com/netdata/go.d.plugin";

  postInstall = ''
    mkdir -p $bin/lib/netdata/conf.d
    cp -r go/src/${goPackagePath}/config/* $bin/lib/netdata/conf.d
  '';

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "Netdata orchestrator for data collection modules written in go";
    homepage = https://github.com/netdata/go.d.plugin;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.lethalman ];
  };
}
