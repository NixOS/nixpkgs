{ lib
, rustPlatform
, fetchFromGitHub
, makeBinaryWrapper
, runtimeShell
, bat
, gnugrep
, gnumake
}:

rustPlatform.buildRustPackage rec {
  pname = "fzf-make";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "kyu08";
    repo = "fzf-make";
    rev = "v${version}";
    hash = "sha256-0fzc18OWCkGiSNNyZgtkv0J3n8C3L/w8UC7ejqt6efs=";
  };

  cargoHash = "sha256-GwqfH5NSJu6kNKg4aa7a+eqZf79JBdF9LxRa207Krwo=";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  postInstall = ''
    wrapProgram $out/bin/fzf-make \
      --set SHELL ${runtimeShell} \
      --suffix PATH : ${lib.makeBinPath [ bat gnugrep gnumake ]}
  '';

  meta = with lib; {
    description = "Fuzzy finder for Makefile";
    homepage = "https://github.com/kyu08/fzf-make";
    changelog = "https://github.com/kyu08/fzf-make/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda sigmanificient ];
    mainProgram = "fzf-make";
  };
}
