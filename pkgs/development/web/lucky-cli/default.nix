{ lib, fetchFromGitHub, crystal, makeWrapper, openssl }:

crystal.buildCrystalPackage rec {
  pname = "lucky-cli";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "luckyframework";
    repo = "lucky_cli";
    rev = "v${version}";
    hash = "sha256-mDUx9cQoYpU9kSAls36kzNVYZ8a4aqHEMIWfzS41NBk=";
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
    description = "Crystal library for creating and running tasks. Also generates Lucky projects";
    homepage = "https://luckyframework.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    mainProgram = "lucky";
    platforms = platforms.unix;
    broken = lib.versionOlder crystal.version "1.6.0";
  };
}
