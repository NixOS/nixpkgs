{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "charasay";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "latipun7";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-99lMXgSHgxKc0GHnRRciMoZ+rQJyMAx+27fj6NkXxds=";
  };

  cargoHash = "sha256-0la16XinseOXPH2mvdYD7ZquvF2dju4UPBwl5VrTEZA=";

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
