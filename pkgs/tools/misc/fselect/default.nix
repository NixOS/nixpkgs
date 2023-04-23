{ lib, stdenv, fetchFromGitHub, rustPlatform, installShellFiles, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "fselect";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "jhspetersson";
    repo = "fselect";
    rev = version;
    sha256 = "sha256-JhiNLlgnVIrecYNlestociTXHBxfUMTQHSzo3/ePXds=";
  };

  cargoHash = "sha256-HOOxr5hBrenziai+TxatgXjMi8G3xqIM8OqdMeeKEgg=";

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
