{ lib, stdenv, fetchFromGitHub, rustPlatform, installShellFiles, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "fselect";
  version = "0.7.9";

  src = fetchFromGitHub {
    owner = "jhspetersson";
    repo = "fselect";
    rev = version;
    sha256 = "sha256-Z1F63tMO3qzi/PrdVR0WCcPXx5E6PwjYPF99Bolnxc8=";
  };

  cargoSha256 = "sha256-tGzfIQ4nAFA/mXPL6cOaz97W5tjtPGsmbTSkUDFSAzY=";

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
