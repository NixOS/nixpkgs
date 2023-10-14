{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mutagen-compose";
  version = "0.17.2";

  src = fetchFromGitHub {
    owner = "mutagen-io";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-FEUVRDGVYYpgNSOSSR9hyUyz9mP8B8qWy3MnTtuE3fQ=";
  };

  vendorHash = "sha256-u4vRQjqBSsugEcBzteV7yOTizbXGpCH+M/zAvdWusK0=";

  doCheck = false;

  subPackages = [ "cmd/mutagen-compose" ];

  tags = [ "mutagencompose" ];

  meta = with lib; {
    description = "Compose with Mutagen integration";
    homepage = "https://mutagen.io/";
    changelog = "https://github.com/mutagen-io/mutagen-compose/releases/tag/v${version}";
    maintainers = [ maintainers.matthewpi ];
    license = licenses.mit;
  };
}
