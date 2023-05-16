{ lib, stdenv, fetchFromGitHub, rustPlatform, installShellFiles, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "fselect";
<<<<<<< HEAD
  version = "0.8.4";
=======
  version = "0.8.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jhspetersson";
    repo = "fselect";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-XCm4gWPuza+LxK6fnDq5wAn3GGC3njtWxWng+FXIwOs=";
  };

  cargoHash = "sha256-XGjXeA2tRJhFbADtrPR11JgmrQI8mK3Rp+ZSIY62H9s=";
=======
    sha256 = "sha256-JhiNLlgnVIrecYNlestociTXHBxfUMTQHSzo3/ePXds=";
  };

  cargoHash = "sha256-HOOxr5hBrenziai+TxatgXjMi8G3xqIM8OqdMeeKEgg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
