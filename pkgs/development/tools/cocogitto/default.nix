{ lib, rustPlatform, fetchFromGitHub, installShellFiles, stdenv, Security, makeWrapper, libgit2 }:

rustPlatform.buildRustPackage rec {
  pname = "cocogitto";
  version = "5.3.0";

  src = fetchFromGitHub {
    owner = "oknozor";
    repo = pname;
    rev = version;
    sha256 = "sha256-BqyV4hJw7H9yN5Kj/XwhYS6hElXdKUJEUi5M/PNlPO0=";
  };

  cargoHash = "sha256-MA3XW2tPn0qVx7ve+UqCoG4nQ7UyuvXEebrPuLKqS4g=";

  # Test depend on git configuration that would likly exist in a normal user enviroment
  # and might be failing to create the test repository it works in.
  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ libgit2 ] ++ lib.optional stdenv.isDarwin Security;

  postInstall = ''
    installShellCompletion --cmd cog \
      --bash <($out/bin/cog generate-completions bash) \
      --fish <($out/bin/cog generate-completions fish) \
      --zsh  <($out/bin/cog generate-completions zsh)
  '';

  meta = with lib; {
    description = "A set of cli tools for the conventional commit and semver specifications";
    homepage = "https://github.com/oknozor/cocogitto";
    license = licenses.mit;
    maintainers = with maintainers; [ travisdavis-ops ];
  };
}
