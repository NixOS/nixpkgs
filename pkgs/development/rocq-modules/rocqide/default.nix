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
  defaultVersion = rocq-core.version;

  # Handle the tricky definition of src for the derivation since the Rocq CI
  # in the `coq-nix-toolbox` have a derivation for the `master` branch of Rocq.
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
in
mkRocqDerivation (
  {
    inherit pname;

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
  // setupSrc
)
