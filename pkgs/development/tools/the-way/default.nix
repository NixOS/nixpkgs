{ lib, stdenv, fetchFromGitHub, rustPlatform, installShellFiles, AppKit, Security }:

rustPlatform.buildRustPackage rec {
  pname = "the-way";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "out-of-cheese-error";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-OqJceRO1RFOLgNi3SbTKLw62tSfJSO7T2/u0RTX89AM=";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin  [ AppKit Security ];

  cargoSha256 = "sha256-sULjd+weixTQYFIQlluPwY4MFlZ1+vMMoMn4GP79oQs=";
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
