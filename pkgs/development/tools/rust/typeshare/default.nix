{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "typeshare";
<<<<<<< HEAD
  version = "1.7.0";
=======
  version = "1.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "1password";
    repo = "typeshare";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Ftr0YMrY6tPpfg25swYntBXLWGKT00PEz79aOiSgLsU=";
  };

  cargoHash = "sha256-VIPIFdbyPcflqHHLkzpDugmw9+9CJRIv+Oy7PoaUZ5g=";
=======
    hash = "sha256-vKjSpjbjTY9YxJGtqyoat6qI9ipmou+HQt35Dhpgk4E=";
  };

  cargoHash = "sha256-dnQttsI6v90TJD8MekaLV63ltl147zBCe3mmfWj6cxs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ installShellFiles ];

  buildFeatures = [ "go" ];

  postInstall = ''
    installShellCompletion --cmd typeshare \
      --bash <($out/bin/typeshare completions bash) \
      --fish <($out/bin/typeshare completions fish) \
      --zsh <($out/bin/typeshare completions zsh)
  '';

  meta = with lib; {
    description = "Command Line Tool for generating language files with typeshare";
    homepage = "https://github.com/1password/typeshare";
    changelog = "https://github.com/1password/typeshare/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
