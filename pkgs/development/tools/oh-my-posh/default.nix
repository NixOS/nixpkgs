{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "oh-my-posh";
  version = "18.1.0";

  src = fetchFromGitHub {
    owner = "jandedobbeleer";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-qK9hjsWhVTzxFo4SSvKb5IgZteVabWlCtoetu9v9xIE=";
  };

  vendorHash = "sha256-cATGMi/nL8dvlsR+cuvKH6Y9eR3UqcVjvZAj35Ydn2c=";

  sourceRoot = "${src.name}/src";

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/jandedobbeleer/oh-my-posh/src/build.Version=${version}"
    "-X github.com/jandedobbeleer/oh-my-posh/src/build.Date=1970-01-01T00:00:00Z"
  ];

  tags = [
    "netgo"
    "osusergo"
    "static_build"
  ];

  postPatch = ''
    # these tests requires internet access
    rm engine/image_test.go engine/migrate_glyphs_test.go
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
