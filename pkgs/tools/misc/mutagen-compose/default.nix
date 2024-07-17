{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mutagen-compose";
  version = "0.17.6";

  src = fetchFromGitHub {
    owner = "mutagen-io";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ZcfwpEfdoSMCGtw5Icj1hXbk5CRYS4LBtdaiX62E4I0=";
  };

  vendorHash = "sha256-XyWi06siSHOKZca0w4WLIFGM63wnF//2rRP4aH5rFAo=";

  doCheck = false;

  subPackages = [ "cmd/mutagen-compose" ];

  tags = [ "mutagencompose" ];

  meta = with lib; {
    description = "Compose with Mutagen integration";
    homepage = "https://mutagen.io/";
    changelog = "https://github.com/mutagen-io/mutagen-compose/releases/tag/v${version}";
    maintainers = [ maintainers.matthewpi ];
    license = licenses.mit;
    mainProgram = "mutagen-compose";
  };
}
