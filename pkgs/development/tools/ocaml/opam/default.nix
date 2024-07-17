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
  Foundation,
}:

assert lib.versionAtLeast ocaml.version "4.08.0";

stdenv.mkDerivation {
  pname = "opam";
  version = "2.2.0";

  src = fetchurl {
    url = "https://github.com/ocaml/opam/releases/download/2.2.0/opam-full-2.2.0-2.tar.gz";
    sha256 = "459ed64e6643f05c677563a000e3baa05c76ce528064e9cb9ce6db49fff37c97";
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
  ] ++ lib.optionals stdenv.isLinux [ bubblewrap ] ++ lib.optionals stdenv.isDarwin [ Foundation ];

  patches = [ ./opam-shebangs.patch ];

  preConfigure = ''
    patchShebangs src/state/shellscripts
  '';

  configureFlags = [
    "--with-vendored-deps"
    "--with-mccs"
  ];

  # Dirty, but apparently ocp-build requires a TERM
  makeFlags = [ "TERM=screen" ];

  outputs = [
    "out"
    "installer"
  ];
  setOutputFlags = false;

  # change argv0 to "opam" as a workaround for
  # https://github.com/ocaml/opam/issues/2142
  postInstall = ''
    mv $out/bin/opam $out/bin/.opam-wrapped
    makeWrapper $out/bin/.opam-wrapped $out/bin/opam \
      --argv0 "opam" \
      --suffix PATH : ${unzip}/bin:${curl}/bin:${lib.optionalString stdenv.isLinux "${bubblewrap}/bin:"}${getconf}/bin \
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
