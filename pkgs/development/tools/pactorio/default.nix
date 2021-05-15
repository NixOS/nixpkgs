{ fetchFromGitHub, installShellFiles, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "pactorio";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "figsoda";
    repo = pname;
    rev = "v${version}";
    sha256 = "07h9hywz0pc29411myhxjq6pks4p6q6czbqjv7fxf3xkb1mg9grq";
  };

  cargoSha256 = "1m7bvi6i52xqvssjx5fr2dz25ny7hkmb8w8p23pczpdmpd2y0r7r";

  nativeBuildInputs = [ installShellFiles ];

  preFixup = ''
    completions=($releaseDir/build/pactorio-*/out/completions)
    installShellCompletion ''${completions[0]}/pactorio.{bash,fish}
    installShellCompletion --zsh ''${completions[0]}/_pactorio
  '';

  GEN_COMPLETIONS = "1";

  meta = with lib; {
    description = "Mod package for factorio";
    homepage = "https://github.com/figsoda/pactorio";
    changelog = "https://github.com/figsoda/pactorio/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
