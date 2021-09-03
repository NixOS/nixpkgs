{ lib, stdenv, fetchFromGitHub, rustPlatform, installShellFiles, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "fselect";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "jhspetersson";
    repo = "fselect";
    rev = version;
    sha256 = "sha256-uIqkk0aQVPXUWjOWmMTdM28Ihi+mflPpxnXJLFIQYJw=";
  };

  cargoSha256 = "sha256-5LRCLJbLiocB/VDf9MMxyIsERmOvuSAQEe822Dcu2j8=";

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
