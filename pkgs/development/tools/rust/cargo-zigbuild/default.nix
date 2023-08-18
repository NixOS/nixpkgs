{ lib, rustPlatform, fetchFromGitHub, makeWrapper, zig }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-zigbuild";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "messense";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/3ThQtAQ0pWEIK4cgqYHqoSXtSJB581NLlsH21UNb50=";
  };

  cargoHash = "sha256-KUjkiS8TyaKdf1qRfgp2/JMwFGLAFfeTNcGIq+Z6oEU=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/cargo-zigbuild \
      --prefix PATH : ${zig}/bin
  '';

  meta = with lib; {
    description = "A tool to compile Cargo projects with zig as the linker";
    homepage = "https://github.com/messense/cargo-zigbuild";
    changelog = "https://github.com/messense/cargo-zigbuild/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
