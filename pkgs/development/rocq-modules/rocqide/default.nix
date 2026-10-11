{
  lib,
  makeDesktopItem,
  copyDesktopItems,
  wrapGAppsHook3,
  glib,
  adwaita-icon-theme,
  mkRocqDerivation,
  rocq-core,
  rocqPackages_9_0,
  rocqPackages_9_1,
  rocqPackages_9_2,
  rocqPackages_9_3,
  rocqide-server,
  version ? null,
}:

let
  pname = "rocqide";
in
mkRocqDerivation {
  inherit pname;
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
  # https://github.com/NixOS/nixpkgs/blob/69cfa0e28f8d311dfe4e543e6b43eda2af9c374f/pkgs/build-support/rocq/default.nix#L256
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
