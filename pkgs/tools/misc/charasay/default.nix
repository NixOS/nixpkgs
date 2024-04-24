{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "charasay";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "latipun7";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7z5+7yrx5X5rdBMNj9oWBZ2IX0s88c1SLhgz2IDDEn8=";
  };

  cargoHash = "sha256-5htNU8l+amh+C8EL1K4UcXzf5Pbhhjd5RhxrucJoj/M=";

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
    mainProgram = "chara";
  };
}
