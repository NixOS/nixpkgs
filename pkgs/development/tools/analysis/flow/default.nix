{ lib, stdenv, fetchFromGitHub, ocamlPackages, CoreServices }:

stdenv.mkDerivation rec {
  pname = "flow";
<<<<<<< HEAD
  version = "0.216.1";
=======
  version = "0.206.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "flow";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-Nx6BAeaJGbrfjmH5dSb8Cb1TG2SDeF+lCeGOLW27cJs=";
=======
    sha256 = "sha256-pDh43pOf/PhyxGcYRnQsuq7FBJz2Wru77QBTEYSobno=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    homepage = "https://flow.org/";
<<<<<<< HEAD
    changelog = "https://github.com/facebook/flow/blob/v${version}/Changelog.md";
=======
    changelog = "https://github.com/facebook/flow/raw/v${version}/Changelog.md";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    platforms = ocamlPackages.ocaml.meta.platforms;
    maintainers = with maintainers; [ marsam puffnfresh ];
  };
}
