{
  lib,
  mkRocqDerivation,
  rocq-core,
  version ? null,
}:

let
  defaultVersion = rocq-core.version;

  setupSrc =
    if
      version == "master"
      || version == "dev"
      || rocq-core.version == "master"
      || rocq-core.version == "dev"
    then
      {
        # Don't use a hash since we can't pin a particular commit if we choose
        # to build the upstream `master` branch of Rocq.
        version = "dev"; # Same behavior as in rocq-core
        src = (rocq-core.override { version = "master"; }).src;
      }
    else
      {
        owner = "rocq-prover";
        repo = "rocq";

        inherit version defaultVersion;

        # Same repository (and release hashes) as rocq-core
        # release = { version = "rocq-core src hash for that version"; };
        release =
          let
            v = if isNull version then defaultVersion else version;
          in
          {
            "${v}".sha256 = (rocq-core.override { version = v; }).src.hash;
          };
        releaseRev = v: "V${v}";
        # NOTE: directly reusing `rocq-core.src` falls into the `case = isString` of
        # the mkRocqDerivation fetcher, causing to set the package version as "dev"
      };

  # Custom versionAtLeast to handle "dev" case
  versionAtLeast' =
    vmin:
    if isNull version then
      defaultVersion == "dev" || lib.versionAtLeast defaultVersion vmin
    else
      version == "dev" || version == "master" || lib.versionAtLeast version vmin;
in
mkRocqDerivation (
  rec {
    pname = "rocqide-server";

    postPatch = ''
      patchShebangs dev/tools/
    '';

    prefixKey = "-prefix ";

    useDune = true;

    # NOTE: the server opam package name still uses coq for Rocq < 9.4
    opam-name = if versionAtLeast' "9.4" then pname else "coqide-server";

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
  // setupSrc
)
