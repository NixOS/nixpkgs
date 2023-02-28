{ lib
, stdenv
, fetchFromGitHub
, installShellFiles
, rustPlatform
, libiconv
, Security
, SystemConfiguration
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "atuin";
  version = "13.0.0";

  src = fetchFromGitHub {
    owner = "ellie";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-liuHleJxRrPWOQ5jL3BD8ErbKNGBeRk9Emvfodqy5dQ=";
  };

  cargoHash = "sha256-WOJurXTLIKTyFrxjnQpDbyrc6U0UvJELvqfG2UbfS4g=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security SystemConfiguration ];

  postInstall = ''
    installShellCompletion --cmd atuin \
      --bash <($out/bin/atuin gen-completions -s bash) \
      --fish <($out/bin/atuin gen-completions -s fish) \
      --zsh <($out/bin/atuin gen-completions -s zsh)
  '';

  passthru.tests = {
    inherit (nixosTests) atuin;
  };

  meta = with lib; {
    description = "Replacement for a shell history which records additional commands context with optional encrypted synchronization between machines";
    homepage = "https://github.com/ellie/atuin";
    license = licenses.mit;
    maintainers = with maintainers; [ onsails SuperSandro2000 sciencentistguy ];
  };
}
