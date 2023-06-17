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
  version = "0.12.4";

  src = fetchFromGitHub {
    owner = "acheronfail";
    repo = "repgrep";
    rev = version;
    hash = "sha256-tMv0MdFlDEYx8lNINfnhX6WgcpVLm1fTlaUddej5KRc=";
  };

  cargoHash = "sha256-NjPFoVPHjwG74ZNStYaNMzwdX488xDjGJu92+UWC2z8=";

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
