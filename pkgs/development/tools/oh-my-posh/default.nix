{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "oh-my-posh";
<<<<<<< HEAD
  version = "18.7.0";
=======
  version = "15.4.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jandedobbeleer";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-dnaKcyDy4TdlTPl0hCUCshW6aFMLUUFwVskv1jiO0fk=";
  };

  vendorHash = "sha256-GHOWcZqZmjL+EptcuCwbj0WSWKmhbsxpZFvHhlmsbxU=";

  sourceRoot = "${src.name}/src";
=======
    hash = "sha256-D1X0/r/OyQKPPE1aEwNVdGJYq6+i67xTvIQK3ZeI7pM=";
  };

  vendorHash = "sha256-4exLY24baDjgGIDS1P7BIK38O4b+KeqNTMzA6wap05k=";

  sourceRoot = "source/src";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
<<<<<<< HEAD
    "-X github.com/jandedobbeleer/oh-my-posh/src/build.Version=${version}"
    "-X github.com/jandedobbeleer/oh-my-posh/src/build.Date=1970-01-01T00:00:00Z"
=======
    "-X main.Version=${version}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  tags = [
    "netgo"
    "osusergo"
    "static_build"
  ];

  postPatch = ''
<<<<<<< HEAD
    # these tests requires internet access
    rm engine/image_test.go engine/migrate_glyphs_test.go
=======
    # this test requires internet access
    rm engine/migrate_glyphs_test.go
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  postInstall = ''
    mv $out/bin/{src,oh-my-posh}
    mkdir -p $out/share/oh-my-posh
    cp -r ${src}/themes $out/share/oh-my-posh/
    installShellCompletion --cmd oh-my-posh \
      --bash <($out/bin/oh-my-posh completion bash) \
      --fish <($out/bin/oh-my-posh completion fish) \
      --zsh <($out/bin/oh-my-posh completion zsh)
  '';

  meta = with lib; {
    description = "A prompt theme engine for any shell";
    homepage = "https://ohmyposh.dev";
    changelog = "https://github.com/JanDeDobbeleer/oh-my-posh/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ lucperkins urandom ];
  };
}
