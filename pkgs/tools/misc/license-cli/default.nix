{ stdenv
, lib
, fetchFromSourcehut
, rustPlatform
, installShellFiles
, scdoc
, makeWrapper

# Script dependencies.
, fzf
, wl-clipboard
, xclip
}:

rustPlatform.buildRustPackage rec {
  pname = "license-cli";
  version = "3.0.0";

  src = fetchFromSourcehut {
    owner = "~zethra";
    repo = "license";
    rev = version;
    hash = "sha256-M5ypymJ99T4Vc7XSmqNb69yBLgSYu9I+6FEQvtFGUf0=";
  };

  cargoHash = "sha256-me4xPP6fO1D+vvR9XZg2EHieY7OU2HHQ4P0nkk/IKpE=";

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  preInstall = ''
    ${scdoc}/bin/scdoc < doc/license.scd > license.1
  '';

  postInstall = ''
    installShellCompletion completions/license.{bash,fish}
    installShellCompletion --zsh completions/_license
    installManPage ./license.1

    install -Dm0755 ./scripts/set-license -t $out/bin
    wrapProgram $out/bin/set-license \
      --prefix PATH : "$out/bin" \
      --prefix PATH : ${lib.makeBinPath [ fzf ]}

    install -Dm0755 ./scripts/copy-header -t $out/bin
    wrapProgram $out/bin/copy-header \
      --prefix PATH : "$out/bin" \
      --prefix PATH : ${lib.makeBinPath [ wl-clipboard xclip ]}
  '';

  meta = with lib; {
    homepage = "https://git.sr.ht/~zethra/license";
    description = "Command-line tool to easily add license to your project";
    license = licenses.mpl20;
    mainProgram = "license";
    maintainers = with maintainers; [ foo-dogsquared ];
  };
}
