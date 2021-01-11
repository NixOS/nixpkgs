{ lib, stdenv, fetchFromGitHub, rustPlatform, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "fselect";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "jhspetersson";
    repo = "fselect";
    rev = version;
    sha256 = "1cqa52n5y6g087w4yzc273jpxhzpinwkqd32azg03dkczbgx5b2v";
  };

  cargoSha256 = "00yhp2b74plrbi944apbxpkw2y6nbgf81sinfchw44ww1i58mfhj";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage docs/fselect.1
  '';

  meta = with lib; {
    description = "Find files with SQL-like queries";
    homepage = "https://github.com/jhspetersson/fselect";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
