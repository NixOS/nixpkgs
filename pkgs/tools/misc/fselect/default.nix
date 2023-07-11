{ lib, stdenv, fetchFromGitHub, rustPlatform, installShellFiles, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "fselect";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "jhspetersson";
    repo = "fselect";
    rev = version;
    sha256 = "sha256-XCm4gWPuza+LxK6fnDq5wAn3GGC3njtWxWng+FXIwOs=";
  };

  cargoHash = "sha256-XGjXeA2tRJhFbADtrPR11JgmrQI8mK3Rp+ZSIY62H9s=";

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
