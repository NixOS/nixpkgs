{ lib
, rustPlatform
, fetchFromGitHub
, asciidoctor
, installShellFiles
, makeWrapper
, ripgrep
}:

rustPlatform.buildRustPackage rec {
  pname = "repgrep";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "acheronfail";
    repo = "repgrep";
    rev = version;
    hash = "sha256-B286fU25GwDB7oqm5sbCoznzm71eKWJuUP8I7BEi7Hs=";
  };

  cargoHash = "sha256-TWu/TQsv8FM60kNPIxn6TiTHgHlKtSjubnfbg6IfS10=";

  nativeBuildInputs = [
    asciidoctor
    installShellFiles
    makeWrapper
  ];

  postInstall = ''
    wrapProgram $out/bin/rgr \
      --prefix PATH : ${lib.makeBinPath [ ripgrep ]}

    pushd "$(dirname "$(find -path '**/repgrep-stamp' | head -n 1)")"
    installManPage rgr.1
    installShellCompletion rgr.{bash,fish} _rgr
    popd
  '';

  meta = with lib; {
    description = "An interactive replacer for ripgrep that makes it easy to find and replace across files on the command line";
    homepage = "https://github.com/acheronfail/repgrep";
    changelog = "https://github.com/acheronfail/repgrep/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ mit asl20 unlicense ];
    maintainers = with maintainers; [ figsoda ];
  };
}
