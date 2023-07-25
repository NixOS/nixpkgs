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
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "acheronfail";
    repo = "repgrep";
    rev = version;
    hash = "sha256-sclBzv3F3M3oARRm0cNg/ABomzfgbDp0cFOXkRYjGEY=";
  };

  cargoHash = "sha256-o6pF32sNiDuCjsBaa5beZyFCv1PoqALZOhAb0GF0XyQ=";

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
    mainProgram = "rgr";
  };
}
