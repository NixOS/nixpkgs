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
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "kyu08";
    repo = "fzf-make";
    rev = "v${version}";
    hash = "sha256-VDPkucvp12pdnJkUxSTfU73X9CMvP/UU1ypBnN0Jp80=";
  };

  cargoHash = "sha256-mLbGV0hj571SiM1ZPiHnADYYICgP8ZfgnMTjo2npIgk=";

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
