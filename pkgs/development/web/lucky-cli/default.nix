{ lib, fetchFromGitHub, crystal, makeWrapper, openssl }:

crystal.buildCrystalPackage rec {
  pname = "lucky-cli";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "luckyframework";
    repo = "lucky_cli";
    rev = "v${version}";
    sha256 = "1qggbczrnrfjba6ipzjkqp6ni4rjc79pxy3vhgd7nq88ipa1sygk";
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
