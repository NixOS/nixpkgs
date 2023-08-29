{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "charasay";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "latipun7";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ijr6AvhoiYWHYTPUxSdBds9jBW1HEy1n7h6zH1VGP1c=";
  };

  cargoHash = "sha256-HCHdiCeb4dqxQMWfYZV2k8Yq963vWfmL05BRpVYmIcg=";

  nativeBuildInputs = [ installShellFiles ];

  postPatch = ''
    rm .cargo/config.toml
  '';

  postInstall = ''
    installShellCompletion --cmd himalaya \
      --bash <($out/bin/chara completion --shell bash) \
      --fish <($out/bin/chara completion --shell fish) \
      --zsh <($out/bin/chara completion --shell zsh)
  '';

  meta = with lib; {
    description = "The future of cowsay - Colorful characters saying something";
    homepage = "https://github.com/latipun7/charasay";
    license = licenses.mit;
    maintainers = with maintainers; [ hmajid2301 ];
  };
}
