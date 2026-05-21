############################################################################
# This file mainly provides the `mathcomp` derivation, which is            #
# essentially a meta-package containing all core mathcomp libraries        #
# (boot order finite-group algebra solvable field group-representation).   #
# They can be accessed individually through the passthrough attributes of  #
# mathcomp bearing the same names (mathcomp.boot, etc).                    #
############################################################################
# Compiling a custom version of mathcomp using `mathcomp.override`.        #
# This is the replacement for the former `mathcomp_ config` function.      #
# See the documentation at doc/languages-frameworks/rocq.section.md.       #
############################################################################

{
  lib,
  ncurses,
  graphviz,
  lua,
  fetchzip,
  mkRocqDerivation,
  withDoc ? false,
  single ? false,
  rocq-core,
  hierarchy-builder,
  micromega-plugin,
  version ? null,
}@args:

let
  repo = "mathcomp";
  owner = "math-comp";
  withDoc = single && (args.withDoc or false);
  defaultVersion =
    let
      case = case: out: { inherit case out; };
      inherit (lib.versions) range;
    in
    lib.switch rocq-core.rocq-version [
      (case (range "9.0" "9.1") "2.5.0")
    ] null;
  release = {
    "2.5.0".sha256 = "sha256-M/6IP4WhTQ4j2Bc8nXBXjSjWO08QzNIYI+a2owfOh+8=";
  };
  releaseRev = v: "mathcomp-${v}";

  # list of core mathcomp packages sorted by dependency order
  packages = {
    "boot" = [ ];
    "order" = [ "boot" ];
    "finite-group" = [ "boot" ];
    "algebra" = [
      "order"
      "finite-group"
    ];
    "solvable" = [ "algebra" ];
    "field" = [ "solvable" ];
    "group-representation" = [ "field" ];
    "all" = [ "group-representation" ];
  };

  mathcomp_ =
    package:
    let
      mathcomp-deps = lib.optionals (package != "single") (map mathcomp_ packages.${package});
      cdpkg =
        if package == "single" then
          "cd ."
        else if package == "group-representation" then
          "cd group_representation || cd character"
        else if package == "finite-group" then
          "cd finite_group || cd fingroup"
        else
          "cd ${package}";
      pname = if package == "single" then "mathcomp" else "mathcomp-${package}";
      pkgallMake = ''
        echo "all.v"  > Make
        echo "-I ." >>   Make
        echo "-R . mathcomp.all" >> Make
      '';
      derivation = mkRocqDerivation (
        {
          inherit
            version
            pname
            defaultVersion
            release
            releaseRev
            repo
            owner
            ;

          nativeBuildInputs = lib.optionals withDoc [
            graphviz
            lua
          ];
          buildInputs = [ ncurses ];
          propagatedBuildInputs = mathcomp-deps ++ [ hierarchy-builder ];

          buildFlags = lib.optional withDoc "doc";

          preBuild = ''
            if [[ -f etc/buildlibgraph ]]
            then patchShebangs etc/buildlibgraph
            fi
          ''
          + ''
            ${cdpkg}
          ''
          + lib.optionalString (package == "all") pkgallMake;

          meta = {
            homepage = "https://math-comp.github.io/";
            license = lib.licenses.cecill-b;
            maintainers = with lib.maintainers; [
              vbgl
              jwiegley
              cohencyril
            ];
          };
        }
        // lib.optionalAttrs (package != "single") { passthru = lib.mapAttrs (p: _: mathcomp_ p) packages; }
        // lib.optionalAttrs withDoc {
          htmldoc_template = fetchzip {
            url = "https://github.com/math-comp/math-comp.github.io/archive/doc-1.12.0.zip";
            sha256 = "0y1352ha2yy6k2dl375sb1r68r1qi9dyyy7dyzj5lp9hxhhq69x8";
          };
          postBuild = ''
            cp -rf _build_doc/* .
            rm -r _build_doc
          '';
          postInstall =
            let
              tgt = "$out/share/coq/${rocq-core.rocq-version}/";
            in
            lib.optionalString withDoc ''
              mkdir -p ${tgt}
              cp -r htmldoc ${tgt}
              cp -r $htmldoc_template/htmldoc_template/* ${tgt}/htmldoc/
            '';
          buildTargets = "doc";
          extraInstallFlags = [ "-f Makefile.coq" ];
        }
      );
      patched-derivation1 = derivation.overrideAttrs (
        o:
        lib.optionalAttrs
          (
            lib.elem package [
              "algebra"
              "single"
            ]
            && o.version != null
            && (o.version == "dev" || lib.versions.isGe "2.6.0" o.version)
          )
          {
            propagatedBuildInputs = o.propagatedBuildInputs ++ [ micromega-plugin ];
          }
      );
    in
    patched-derivation1;
in
mathcomp_ (if single then "single" else "all")
