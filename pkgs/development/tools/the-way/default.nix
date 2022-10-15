{ lib, stdenv, fetchFromGitHub, rustPlatform, installShellFiles, AppKit, Security }:

rustPlatform.buildRustPackage rec {
  pname = "the-way";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "out-of-cheese-error";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Imo1CUk2H4/K9w/FnIBEkKFXd7OIAuApejcNY+rs7JU=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin  [ AppKit Security ];

  cargoSha256 = "sha256-3ZiNRXrb3gpXXOxztf0eimJE16PpQTD/OWFmeTDIr2w=";
  checkFlagsArray = lib.optionals stdenv.isDarwin [ "--skip=copy" ];
  dontUseCargoParallelTests = true;

  postInstall = ''
    $out/bin/the-way config default tmp.toml
    for shell in bash fish zsh; do
      THE_WAY_CONFIG=tmp.toml $out/bin/the-way complete $shell > the-way.$shell
      installShellCompletion the-way.$shell
    done
  '';

  meta = with lib; {
    description = "Terminal code snippets manager";
    homepage = "https://github.com/out-of-cheese-error/the-way";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ numkem ];
  };
}
