{ lib, rustPlatform, fetchFromGitHub, installShellFiles, stdenv, Security, makeWrapper, git }:

rustPlatform.buildRustPackage rec {
  pname = "cocogitto";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "oknozor";
    repo = pname;
    rev = version;
    sha256 = "sha256-g7NBtqr7Mx7ALzij4hfoVXN3izbu4ShXYhHPYw9qnWk=";
  };

  cargoSha256 = "sha256-kXspbXySY5ridLUvAjv49Rm0RGt1fNsfNw9a3vd4hyI=";

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
