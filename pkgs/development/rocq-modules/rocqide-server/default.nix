{
  lib,
  mkRocqDerivation,
  rocq-core,
  rocqPackages_9_0,
  rocqPackages_9_1,
  rocqPackages_9_2,
  rocqPackages_9_3,
  version ? null,
}:

let
  # Check if string `x` is a version (e.g. "9.2.0" or "9.2")
  # Initial definition
  isRocqVersion = x: lib.isString x && lib.strings.match "^([0-9]+)(\\.[0-9]+)*$" x != null;

  # Check if the version that is selected will be at most (exclusive) vMax
  versionAtMost =
    v: vdefault: vmax:
    if isNull v then
      lib.strings.versionOlder vdefault vmax # vdefault < vmax
    else if isRocqVersion version then
      lib.strings.versionOlder v vmax # v < vmax
    else
      # If version is not a "usual version", we assume it will be a late
      # revision of a dev build, thus we have a good chance of version > vmax
      false;
in
mkRocqDerivation rec {
  pname = "rocqide-server";
  owner = "rocq-prover";
  repo = "rocq";

  inherit version;
  defaultVersion =
    let
      case = case: out: { inherit case out; };
    in
    with lib.versions;
    lib.switch rocq-core.version [
      (case (isEq "9.3") "9.3.0")
      (case (isEq "9.2") "9.2.0")
      (case (isEq "9.1") "9.1.1")
      (case (isEq "9.0") "9.0.1")
    ] null;
  releaseRev = v: "V${v}";
  # NOTE: directly reusing `rocq-core.src` falls into the `case = isString` of
  # the mkRocqDerivation fetcher, causing to set the package version as "dev"

  # Same repository (and release hashes) as rocq-core
  release = {
    "9.0.1".sha256 = rocqPackages_9_0.rocq-core.src.hash;
    "9.1.1".sha256 = rocqPackages_9_1.rocq-core.src.hash;
    "9.2.0".sha256 = rocqPackages_9_2.rocq-core.src.hash;
    "9.3.0".sha256 = rocqPackages_9_3.rocq-core.src.hash;
  };

  postPatch = ''
    patchShebangs dev/tools/
  '';

  prefixKey = "-prefix ";

  useDune = true;

  # NOTE: the server opam package name still uses coq for Rocq < 9.4
  opam-name = if versionAtMost version defaultVersion "9.4" then "coqide-server" else pname;

  buildInputs = [
    rocq-core
  ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    dune runtest -p ${opam-name} -j $NIX_BUILD_CORES
    runHook postCheck
  '';

  createFindlibDestdir = true;
  # Override the whole installPhase since useDune=true still uses broken `coq`
  # related commands that fail currently
  # https://github.com/NixOS/nixpkgs/blob/69cfa0e28f8d311dfe4e543e6b43eda2af9c374f/pkgs/build-support/rocq/default.nix#L256
  installPhase = ''
    runHook preInstall
    dune install --prefix $out ${opam-name}
    ln -s $out/lib/${opam-name} $OCAMLFIND_DESTDIR/${opam-name}
    runHook postInstall
  '';
  postInstall = ''
    # Provide Rocq friendly names for future updates
    ln -s $out/bin/coqidetop $out/bin/rocqidetop
  ''
  + (
    if opam-name != pname then
      ''
        ln -s $out/lib/${opam-name} $out/lib/${pname}
        # Don't forget the OCaml findlib link
        ln -s $out/lib/${pname} $OCAMLFIND_DESTDIR/${pname}
      ''
    else
      ""
  );

  meta = {
    homepage = "https://rocq-prover.org";
    description = "The Rocq Prover, XML protocol server";
    mainProgram = "coqidetop"; # Kept with `coq` for compatibility reasons
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ hugomartel ];
  };
}
