{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, AppKit
, Cocoa
, Foundation
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "topgrade";
<<<<<<< HEAD
  version = "12.0.2";
=======
  version = "11.0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "topgrade-rs";
    repo = "topgrade";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-PfrtTegJULzPAmKUk/6P9rD+ttPJOhaf2505og64C0Y=";
  };

  cargoHash = "sha256-S6jSI/KuHocYD2dhg3o1NSyA8Q04Xo215TWl8Y1C7g8=";
=======
    hash = "sha256-0pMaFEkzyZkZ7bkPK4hJDjCo/OWYreG+/zyaPl1sNso=";
  };

  cargoHash = "sha256-RqJKwk3MeSYx4kfyzF55A7GltM5PZynHbRYCFFj9JkQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    AppKit
    Cocoa
    Foundation
  ];

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.isDarwin [
    "-framework"
    "AppKit"
  ]);

  postInstall = ''
    installShellCompletion --cmd topgrade \
      --bash <($out/bin/topgrade --gen-completion bash) \
      --fish <($out/bin/topgrade --gen-completion fish) \
      --zsh <($out/bin/topgrade --gen-completion zsh)

    $out/bin/topgrade --gen-manpage > topgrade.8
    installManPage topgrade.8
  '';

  meta = with lib; {
    description = "Upgrade all the things";
    homepage = "https://github.com/topgrade-rs/topgrade";
    changelog = "https://github.com/topgrade-rs/topgrade/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ SuperSandro2000 xyenon ];
  };
}
