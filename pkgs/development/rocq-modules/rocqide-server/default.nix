{
  lib,
  mkRocqDerivation,
  rocq-core,
  version ? null,
}:

let
  # If the version is not set, use the rocq-core version
  version' = if isNull version then rocq-core.version else version;
  rocq-core' = rocq-core.override { version = version'; };
in
mkRocqDerivation rec {
  pname = "rocqide-server";
  owner = "rocq-prover";
  repo = "rocq";

  # rocq-core version is used as a default version
  version = version';
  inherit (rocq-core) rocq-version;

  # Same repository (and release hashes) as rocq-core
  # release = { version = "rocq-core src hash for that version"; };
  release = {
    "${version'}".sha256 = (rocq-core'.src.hash);
  };
  releaseRev = v: "V${v}";
  # NOTE: directly reusing `rocq-core.src` falls into the `case = isString` of
  # the mkRocqDerivation fetcher, causing to set the package version as "dev"

  postPatch = ''
    patchShebangs dev/tools/
  '';

  prefixKey = "-prefix ";

  useDune = true;

  # NOTE: the server opam package name still uses coq for Rocq < 9.4
  opam-name = if lib.versionAtLeast version "9.4" then "rocqide-server" else "coqide-server";

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
  # [/pkgs/build-support/rocq/default.nix#L225]
  installPhase = ''
    runHook preInstall
    dune install --prefix $out ${opam-name}
    ln -s $out/lib/${opam-name} $OCAMLFIND_DESTDIR/${opam-name}
    runHook postInstall
  '';
  postInstall = ''
    # Provide Rocq friendly names for future updates
    ln -s $out/bin/coqidetop $out/bin/rocqidetop
    ln -s $out/lib/${opam-name} $out/lib/${pname}
    # Don't forget the OCaml findlib link
    ln -s $out/lib/${pname} $OCAMLFIND_DESTDIR/${pname}
  '';

  meta = {
    homepage = "https://rocq-prover.org";
    description = "The Rocq Prover, XML protocol server";
    mainProgram = "coqidetop"; # Kept with `coq` for compatibility reasons
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ hugomartel ];
  };
}
