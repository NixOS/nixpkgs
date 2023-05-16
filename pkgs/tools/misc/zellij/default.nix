{ lib
, fetchFromGitHub
, rustPlatform
, stdenv
, installShellFiles
, pkg-config
, libiconv
, openssl
, DiskArbitration
, Foundation
, mandown
, zellij
, testers
}:

rustPlatform.buildRustPackage rec {
  pname = "zellij";
<<<<<<< HEAD
  version = "0.38.1";
=======
  version = "0.36.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "zellij-org";
    repo = "zellij";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-3khMo5qMG0qonMnPvuErVYFohUrZLAkaxKZzkMHou8E=";
  };

  cargoHash = "sha256-d4UNkbp/ryN/VbK8VO8oYvZ1j6qHKeLRSDqgdT+zIeU=";
=======
    sha256 = "sha256-6hd4vZfcztD+i3hRP057Z9kYbl/QYK7e5X18tKRmNVQ=";
  };

  cargoSha256 = "sha256-71HQ/75tl6ogGm5geDPZtz8oYCxUkAWUrU1lhK2AG0c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    mandown
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    libiconv
    DiskArbitration
    Foundation
  ];

  preCheck = ''
    HOME=$TMPDIR
  '';

  postInstall = ''
    mandown docs/MANPAGE.md > zellij.1
    installManPage zellij.1

    installShellCompletion --cmd $pname \
      --bash <($out/bin/zellij setup --generate-completion bash) \
      --fish <($out/bin/zellij setup --generate-completion fish) \
      --zsh <($out/bin/zellij setup --generate-completion zsh)
  '';

  passthru.tests.version = testers.testVersion { package = zellij; };

  meta = with lib; {
    description = "A terminal workspace with batteries included";
    homepage = "https://zellij.dev/";
    changelog = "https://github.com/zellij-org/zellij/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ therealansh _0x4A6F abbe thehedgeh0g ];
<<<<<<< HEAD
    mainProgram = "zellij";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
