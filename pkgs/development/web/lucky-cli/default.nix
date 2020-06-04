{ lib, fetchFromGitHub, crystal, makeWrapper, openssl }:

crystal.buildCrystalPackage rec {
  pname = "lucky-cli";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "luckyframework";
    repo = "lucky_cli";
    rev = "v${version}";
    sha256 = "0g0arf13brh6g0hynxs8bsp8jh3dd66rmf2d3qh2qjvk10101g0r";
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
