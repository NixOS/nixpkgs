{
  stdenv,
  lib,
  fetchurl,
  makeWrapper,
  getconf,
  ocaml,
  unzip,
  ncurses,
  curl,
  bubblewrap,
}:

assert lib.versionAtLeast ocaml.version "4.08.0";

stdenv.mkDerivation (finalAttrs: {
  pname = "opam";
  version = "2.5.0";

  src = fetchurl {
    url = "https://github.com/ocaml/opam/releases/download/${finalAttrs.version}/opam-full-${finalAttrs.version}.tar.gz";
    hash = "sha256-JfuY+WLEInwSYeFCr8aKQWd45ugZYAvV7j7EoYrh4jg=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    unzip
    ocaml
    curl
  ];
  buildInputs = [
    ncurses
    getconf
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ bubblewrap ];

  patches = [ ./opam-shebangs.patch ];

  configureFlags = [
    "--with-vendored-deps"
    "--with-mccs"
  ];

  outputs = [
    "out"
    "installer"
  ];
  setOutputFlags = false;

  postInstall = ''
    wrapProgram $out/bin/opam \
      --suffix PATH : ${
        lib.makeBinPath (
          [
            curl
            getconf
            unzip
          ]
          ++ lib.optionals stdenv.hostPlatform.isLinux [ bubblewrap ]
        )
      }
    $out/bin/opam-installer --prefix=$installer opam-installer.install
  '';

  doCheck = false;

  meta = {
    description = "Package manager for OCaml";
    homepage = "https://opam.ocaml.org/";
    changelog = "https://github.com/ocaml/opam/raw/${finalAttrs.version}/CHANGES";
    maintainers = [ ];
    license = lib.licenses.lgpl21Only;
    platforms = lib.platforms.all;
  };
})
