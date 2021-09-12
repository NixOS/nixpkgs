{ fetchFromGitHub, installShellFiles, lib, stdenv, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "pactorio";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "figsoda";
    repo = pname;
    rev = "v${version}";
    sha256 = "07h9hywz0pc29411myhxjq6pks4p6q6czbqjv7fxf3xkb1mg9grq";
  };

  cargoSha256 = "1rac2s36j88vm231aji8d0ndfbaa2gzxwsrxrvsi0zp9cqisc6rh";

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = lib.optional stdenv.isDarwin Security;

  preFixup = ''
    completions=($releaseDir/build/pactorio-*/out/completions)
    installShellCompletion ''${completions[0]}/pactorio.{bash,fish}
    installShellCompletion --zsh ''${completions[0]}/_pactorio
  '';

  GEN_COMPLETIONS = "1";

  meta = with lib; {
    description = "Mod packager for factorio";
    homepage = "https://github.com/figsoda/pactorio";
    changelog = "https://github.com/figsoda/pactorio/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
