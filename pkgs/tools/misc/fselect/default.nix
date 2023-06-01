{ lib, stdenv, fetchFromGitHub, rustPlatform, installShellFiles, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "fselect";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "jhspetersson";
    repo = "fselect";
    rev = version;
    sha256 = "sha256-f0fc+gj6t1PPdMekYzuZCy2WJrjssLzdsxFoBdFRKBM=";
  };

  cargoHash = "sha256-nYavH8D3dQsr9tKB7PFETGp+KgTm/1EhRtAdTqbwrzQ=";

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = lib.optional stdenv.isDarwin libiconv;

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
