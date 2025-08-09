{
  lib,
  stdenv,
  fetchFromGitHub,
  ocamlPackages,
}:

stdenv.mkDerivation rec {
  pname = "flow";
  version = "0.274.2";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "flow";
    tag = "v${version}";
    hash = "sha256-ZktRFFgPvIfbsAY3C6g3s3zqX3wES+QShu811m183cA=";
  };

  makeFlags = [ "FLOW_RELEASE=1" ];

  installPhase = ''
    install -Dm755 bin/flow $out/bin/flow
    install -Dm644 resources/shell/bash-completion $out/share/bash-completion/completions/flow
  '';

  strictDeps = true;

  nativeBuildInputs = with ocamlPackages; [
    ocaml
    dune_3
    findlib
    ocamlbuild
  ];

  buildInputs = (
    with ocamlPackages;
    [
      camlp-streams
      dtoa
      fileutils
      lwt_log
      lwt_ppx
      lwt
      ppx_deriving
      ppx_gen_rec
      ppx_let
      sedlex
      visitors
      wtf8
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ inotify ]
  );

  meta = with lib; {
    description = "Static type checker for JavaScript";
    mainProgram = "flow";
    homepage = "https://flow.org/";
    changelog = "https://github.com/facebook/flow/blob/v${version}/Changelog.md";
    license = licenses.mit;
    platforms = ocamlPackages.ocaml.meta.platforms;
    maintainers = with maintainers; [ puffnfresh ];
  };
}
