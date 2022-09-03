{ lib, fetchFromGitHub, crystal, makeWrapper, openssl }:

crystal.buildCrystalPackage rec {
  pname = "lucky-cli";
  version = "0.30.0";

  src = fetchFromGitHub {
    owner = "luckyframework";
    repo = "lucky_cli";
    rev = "v${version}";
    hash = "sha256-fgrfVqRcb8xdvZ33XW3lBwR1GhjF/WeAglrPH2Fw31I=";
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
    description = "A Crystal library for creating and running tasks. Also generates Lucky projects";
    homepage = "https://luckyframework.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    mainProgram = "lucky";
    platforms = platforms.unix;
    broken = lib.versionOlder crystal.version "0.35.1";
  };
}
