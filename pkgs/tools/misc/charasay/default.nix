{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, stdenv
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

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd chara \
      --bash <($out/bin/chara completions --shell bash) \
      --fish <($out/bin/chara completions --shell fish) \
      --zsh <($out/bin/chara completions --shell zsh)
  '';

  meta = with lib; {
    description = "Future of cowsay - Colorful characters saying something";
    homepage = "https://github.com/latipun7/charasay";
    license = licenses.mit;
    maintainers = with maintainers; [ hmajid2301 ];
    mainProgram = "chara";
  };
}
