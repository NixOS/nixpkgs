{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchzip,
  # Used to enable SSPL licensed code.
  withSSPL ? false,
}:

buildGoModule rec {
  pname = "mutagen-compose";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "mutagen-io";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-kw+/HG6UfbocWeCoI2Bk/wjL+4lUl7B/OOg/ImYTOQQ=";
  };

  vendorHash = "sha256-A4nLRzgkg8xbODlKyNRg04Qpwd8tUyG44M7zYw1p96U=";

  doCheck = false;

  subPackages = [ "cmd/mutagen-compose" ];

  tags = [ "mutagencompose" ] ++ lib.optional withSSPL "mutagensspl";

  meta = with lib; {
    description = "Compose with Mutagen integration";
    homepage = "https://mutagen.io/";
    changelog = "https://github.com/mutagen-io/mutagen-compose/releases/tag/v${version}";
    maintainers = [ maintainers.matthewpi ];
    license = if withSSPL then licenses.sspl else licenses.mit;
  };
}
