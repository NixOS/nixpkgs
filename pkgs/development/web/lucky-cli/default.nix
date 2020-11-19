{ lib, fetchFromGitHub, crystal, makeWrapper, openssl }:

crystal.buildCrystalPackage rec {
  pname = "lucky-cli";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "luckyframework";
    repo = "lucky_cli";
    rev = "v${version}";
    sha256 = "1z1ns6lx5v6nd5s78brpx7jarc9aldca5yrqjrdb14iyw0jlxig4";
  };

  # the integration tests will try to clone a remote repos
  postPatch = ''
    rm -rf spec/integration
  '';

  format = "crystal";

  lockFile = ./shard.lock;
  shardsFile = ./shards.nix;

  crystalBinaries.lucky.src = "src/lucky.cr";

  buildInputs = [ openssl ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/lucky \
      --prefix PATH : ${lib.makeBinPath [ crystal ]}
  '';

  meta = with lib; {
    description =
      "A Crystal library for creating and running tasks. Also generates Lucky projects";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
  };
}
