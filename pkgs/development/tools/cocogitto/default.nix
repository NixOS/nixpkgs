{ lib, rustPlatform, fetchFromGitHub, installShellFiles, stdenv, Security, makeWrapper, git }:

rustPlatform.buildRustPackage rec {
  pname = "cocogitto";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "oknozor";
    repo = pname;
    rev = version;
    sha256 = "sha256-uSKzHo1lEBiXsi1rOKvfD2zVlkAUVZ5k0y8iiTXYE2A=";
  };

  cargoSha256 = "sha256-gss3+XXyM//zER3gnN9qemIWaVDfs/f4gljmukMxoq0=";

  # Test depend on git configuration that would likly exist in a normal user enviroment
  # and might be failing to create the test repository it works in.
  doCheck = false;

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  buildInputs = lib.optional stdenv.isDarwin Security;

  postInstall = ''
    installShellCompletion --cmd cog \
      --bash <($out/bin/cog generate-completions bash) \
      --fish <($out/bin/cog generate-completions fish) \
      --zsh  <($out/bin/cog generate-completions zsh)

    wrapProgram $out/bin/cog \
      --prefix PATH : "${lib.makeBinPath [ git ]}"
    wrapProgram $out/bin/coco \
      --prefix PATH : "${lib.makeBinPath [ git ]}"
  '';

  meta = with lib; {
    description = "A set of cli tools for the conventional commit and semver specifications";
    homepage = "https://github.com/oknozor/cocogitto";
    license = licenses.mit;
    maintainers = with maintainers; [ travisdavis-ops ];
  };
}
