{ stdenv, lib, fetchurl, makeWrapper, getconf,
  ocaml, unzip, ncurses, curl, bubblewrap, Foundation
}:

assert lib.versionAtLeast ocaml.version "4.08.0";

stdenv.mkDerivation {
  pname = "opam";
  version = "2.3.0";

  src = fetchurl {
    url = "https://github.com/ocaml/opam/releases/download/2.3.0/opam-full-2.3.0.tar.gz";
    hash = "sha256-UGunaGXcMVtn35qonnq9XBqJen8KkteyaUl0/cUys0Y=";
  };

  strictDeps = true;

  nativeBuildInputs = [ makeWrapper unzip ocaml curl ];
  buildInputs = [ ncurses getconf ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ bubblewrap ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ Foundation ];

  patches = [ ./opam-shebangs.patch ];

  preConfigure = ''
    patchShebangs src/state/shellscripts
  '';

  configureFlags = [ "--with-vendored-deps" "--with-mccs" ];

  # Dirty, but apparently ocp-build requires a TERM
  makeFlags = ["TERM=screen"];

  outputs = [ "out" "installer" ];
  setOutputFlags = false;

  # change argv0 to "opam" as a workaround for
  # https://github.com/ocaml/opam/issues/2142
  postInstall = ''
    mv $out/bin/opam $out/bin/.opam-wrapped
    makeWrapper $out/bin/.opam-wrapped $out/bin/opam \
      --argv0 "opam" \
      --suffix PATH : ${unzip}/bin:${curl}/bin:${lib.optionalString stdenv.hostPlatform.isLinux "${bubblewrap}/bin:"}${getconf}/bin \
      --set OPAM_USER_PATH_RO /run/current-system/sw/bin:/nix/
    $out/bin/opam-installer --prefix=$installer opam-installer.install
  '';

  doCheck = false;

  meta = with lib; {
    description = "Package manager for OCaml";
    homepage = "https://opam.ocaml.org/";
    changelog = "https://github.com/ocaml/opam/raw/${version}/CHANGES";
    maintainers = [ ];
    license = licenses.lgpl21Only;
    platforms = platforms.all;
  };
}
