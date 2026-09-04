{
  lib,
  makeDesktopItem,
  copyDesktopItems,
  wrapGAppsHook3,
  glib,
  adwaita-icon-theme,
  mkRocqDerivation,
  rocq-core,
  rocqide-server,
  version ? null,
}:

let
  pname = "rocqide";
  # If the version is not set, use the rocq-core version as a default
  version' = if isNull version then rocq-core.version else version;
  rocq-core' = rocq-core.override { version = version'; };
in
mkRocqDerivation {
  inherit pname;
  owner = "rocq-prover";
  repo = "rocq";

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
    # RocqIDE relies on the `coqidetop` binary being available at runtime
    # Patch RocqIDE looking for coqidetop in its install directory
    # <https://github.com/rocq-prover/rocq/blob/6df5ae331262750d9fc2d115dd2198a6373e4dd0/ide/rocqide/ideutils.ml#L409>
    substituteInPlace ide/rocqide/ideutils.ml \
      --replace-fail 'System.get_toplevel_path "coqidetop"' '"${lib.getExe rocqide-server}"'
  '';

  prefixKey = "-prefix ";

  useDune = true;
  opam-name = pname;

  buildInputs = [
    copyDesktopItems
    wrapGAppsHook3
    rocq-core.ocamlPackages.lablgtk3-sourceview3
    glib
    adwaita-icon-theme
    rocqide-server
  ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    dune runtest -p ${pname} -j $NIX_BUILD_CORES
    runHook postCheck
  '';

  # Override the whole installPhase since useDune=true still uses broken `coq`
  # related commands that fail currently
  # [/pkgs/build-support/rocq/default.nix#L225]
  installPhase = ''
    runHook preInstall
    dune install --prefix $out ${pname}
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = "rocqide";
      icon = "coq";
      desktopName = "RocqIDE";
      comment = "Graphical interface for the Rocq Prover";
      categories = [
        "Development"
        "Science"
        "Math"
        "IDE"
        "GTK"
      ];
    })
  ];

  meta = {
    homepage = "https://rocq-prover.org";
    description = "RocqIDE user interface for the Rocq Prover";
    mainProgram = "rocqide";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ hugomartel ];
  };
}
