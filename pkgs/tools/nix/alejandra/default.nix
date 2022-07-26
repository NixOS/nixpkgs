{ lib
, rustPlatform
, fetchFromGitHub
, testers
, alejandra
}:

rustPlatform.buildRustPackage rec {
  pname = "alejandra";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "kamadorueda";
    repo = "alejandra";
    rev = version;
    sha256 = "sha256-imWi48JxT7l/1toc7NElP1/CBEbChTQ3n0gjBz6L7so=";
  };

  cargoSha256 = "sha256-pcNU7Wk98LQuRg/ItsJ+dxXcSdYROJVYifF74jIrqEo=";

  passthru.tests = {
    version = testers.testVersion { package = alejandra; };
  };

  meta = with lib; {
    description = "The Uncompromising Nix Code Formatter";
    homepage = "https://github.com/kamadorueda/alejandra";
    changelog = "https://github.com/kamadorueda/alejandra/blob/${version}/CHANGELOG.md";
    license = licenses.unlicense;
    maintainers = with maintainers; [ _0x4A6F kamadorueda ];
  };
}
