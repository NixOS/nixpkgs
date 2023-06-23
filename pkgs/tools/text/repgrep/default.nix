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
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "acheronfail";
    repo = "repgrep";
    rev = version;
    hash = "sha256-B3p1h1A8To7yDdioTr7d+C4/231YA7F45QKnzPb0AZs=";
  };

  cargoHash = "sha256-V2jsH48QavHlCQQ3w3IoqlgOkY3SKXwVYhoa4KURruk=";

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
