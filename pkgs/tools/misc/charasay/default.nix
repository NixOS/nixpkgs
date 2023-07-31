{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
}:

rustPlatform.buildRustPackage rec {
  pname = "charasay";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "latipun7";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Cq7pHW4CYGHdVAhscyiOHSdi5Lefk5ve32EOqS2oSRk=";
  };

  cargoHash = "sha256-/9ex5rIYtJVsuwpOpCZLgFSHEdntbnkOX1oRaZ02AOg=";

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
