{ lib, rustPlatform, fetchFromGitHub, installShellFiles, stdenv, Security, makeWrapper, libgit2 }:

rustPlatform.buildRustPackage rec {
  pname = "cocogitto";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "oknozor";
    repo = pname;
    rev = version;
    sha256 = "sha256-yGwGWXME9ZjFJk/3pVDRTa1phG6kd8+YhXe/MxOEdF0=";
  };

  cargoHash = "sha256-iS/nRfy63bgo7MeL/5jJ3Vn6S7dG49erIZ+0516YxKM=";

  # Test depend on git configuration that would likely exist in a normal user environment
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
    mainProgram = "cog";
    homepage = "https://github.com/oknozor/cocogitto";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
