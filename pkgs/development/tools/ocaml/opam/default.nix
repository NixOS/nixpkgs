{ stdenv, lib, fetchurl, makeWrapper, getconf,
  ocaml, unzip, ncurses, curl, bubblewrap, Foundation
}:

assert lib.versionAtLeast ocaml.version "4.08.0";

stdenv.mkDerivation (finalAttrs: {
  pname = "opam";
  version = "2.3.0";

  src = fetchurl {
    url = "https://github.com/ocaml/opam/releases/download/${finalAttrs.version}/opam-full-${finalAttrs.version}.tar.gz";
    hash = "sha256-UGunaGXcMVtn35qonnq9XBqJen8KkteyaUl0/cUys0Y=";
  };

  strictDeps = true;

  nativeBuildInputs = [ makeWrapper unzip ocaml curl ];
  buildInputs = [ ncurses getconf ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ bubblewrap ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ Foundation ];

  patches = [ ./opam-shebangs.patch ];

  preConfigure = ''
    # Fix opam sandboxing on nixos. Remove after opam >= 2.4.0 is released
    substituteInPlace src/state/shellscripts/bwrap.sh \
      --replace-fail 'for dir in /*; do' 'for dir in /{*,run/current-system/sw}; do'
  '';

  configureFlags = [ "--with-vendored-deps" "--with-mccs" ];

  outputs = [ "out" "installer" ];
  setOutputFlags = false;

  postInstall = ''
    wrapProgram $out/bin/opam \
      --suffix PATH : ${lib.makeBinPath ([ curl getconf unzip ] ++ lib.optionals stdenv.hostPlatform.isLinux [ bubblewrap ])}
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
