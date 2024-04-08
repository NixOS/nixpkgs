{ lib, stdenv, fetchFromGitHub, ocamlPackages, CoreServices }:

stdenv.mkDerivation rec {
  pname = "flow";
  version = "0.231.0";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "flow";
    rev = "v${version}";
    hash = "sha256-xZ6hyAnfWMwNZfkDIPV+0Cjs/HBMwBME6tZwQW38Cmk=";
  };

  postPatch = ''
    substituteInPlace src/services/inference/check_cache.ml --replace 'Core_kernel' 'Core'
  '';

  makeFlags = [ "FLOW_RELEASE=1" ];

  installPhase = ''
    install -Dm755 bin/flow $out/bin/flow
    install -Dm644 resources/shell/bash-completion $out/share/bash-completion/completions/flow
  '';

  strictDeps = true;

  nativeBuildInputs = with ocamlPackages; [ ocaml dune_3 findlib ocamlbuild ];

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ]
    ++ (with ocamlPackages; [ core_kernel dtoa fileutils lwt_log lwt_ppx ocaml_lwt ppx_deriving ppx_gen_rec ppx_let sedlex visitors wtf8 ] ++ lib.optionals stdenv.isLinux [ inotify ]);

  meta = with lib; {
    description = "A static type checker for JavaScript";
    mainProgram = "flow";
    homepage = "https://flow.org/";
    changelog = "https://github.com/facebook/flow/blob/v${version}/Changelog.md";
    license = licenses.mit;
    platforms = ocamlPackages.ocaml.meta.platforms;
    maintainers = with maintainers; [ marsam puffnfresh ];
  };
}
