{ stdenv, lib, buildGoModule, fetchFromGitHub, fetchzip }:

buildGoModule rec {
  pname = "mutagen-compose";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "mutagen-io";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-B1UpN9lNMmWe4FtKos2RAGb0ef3xODeGrjD2MwkAYAI=";
  };

  vendorHash = "sha256-uILyJV6Lc4zZeqSl9JMlcUYAs0jDblsIPQKwgg2WOX8=";

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
