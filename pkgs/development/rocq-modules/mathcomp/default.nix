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
  micromega-plugin ? null,
  stdlib,
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
      (case (range "9.2" "9.3") "2.6.0") # also compiles on Rocq 9.0 and 9.1
      (case (range "8.20" "9.1") "2.5.0")
      (case (range "8.20" "9.1") "2.4.0")
      (case (range "8.19" "9.0") "2.3.0")
      (case (range "8.17" "8.20") "2.2.0")
      (case (range "8.17" "8.18") "2.1.0")
      (case (range "8.17" "8.18") "2.0.0")
      (case (range "8.19" "8.20") "1.19.0")
      (case (range "8.17" "8.18") "1.18.0")
      (case (range "8.15" "8.18") "1.17.0")
      (case (range "8.13" "8.18") "1.16.0")
      (case (range "8.14" "8.16") "1.15.0")
      (case (range "8.11" "8.15") "1.14.0")
      (case (range "8.11" "8.15") "1.13.0")
      (case (range "8.10" "8.13") "1.12.0")
      (case (range "8.7" "8.12") "1.11.0")
      (case (range "8.7" "8.11") "1.10.0")
      (case (range "8.7" "8.11") "1.9.0")
      (case (range "8.7" "8.9") "1.8.0")
    ] null;
  release = {
    "2.6.0".sha256 = "sha256-SovoQ++213r8ISljts81j9E9G1vxVrFy+hhpsCw1fDY=";
    "2.5.0".sha256 = "sha256-M/6IP4WhTQ4j2Bc8nXBXjSjWO08QzNIYI+a2owfOh+8=";
    "2.4.0".hash = "sha256-A1XgLLwZRvKS8QyceCkSQa7ue6TYyf5fMft5gSx9NOs=";
    "2.3.0".hash = "sha256-wa6OBig8rhAT4iwupSylyCAMhO69rADa0MQIX5zzL+Q=";
    "2.2.0".hash = "sha256-SPyWSI5kIP5w7VpgnQ4vnK56yEuWnJylNQOT7M77yoQ=";
    "2.1.0".hash = "sha256-XDLx0BIkVRkSJ4sGCIE51j3rtkSGemNTs/cdVmTvxqo=";
    "2.0.0".hash = "sha256-dpOmrHYUXBBS9kmmz7puzufxlbNpIZofpcTvJFLG5DI=";
    "1.19.0".hash = "sha256-3kxS3qA+7WwQkXoFC/+kq3OEkv4kMEzQ/G3aXPsp1Q4=";
    "1.18.0".hash = "sha256-mJJ/zvM2WtmBZU3U4oid/zCMvDXei/93v5hwyyqwiiY=";
    "1.17.0".hash = "sha256-bUfoSTMiW/GzC1jKFay6DRqGzKPuLOSUsO6/wPSFwNg=";
    "1.16.0".hash = "sha256-gXTKhRgSGeRBUnwdDezMsMKbOvxdffT+kViZ9e1gEz0=";
    "1.15.0".hash = "sha256:1bp0jxl35ms54s0mdqky15w9af03f3i0n06qk12k4gw1xzvwqv21";
    "1.14.0".hash = "sha256:07yamlp1c0g5nahkd2gpfhammcca74ga2s6qr7a3wm6y6j5pivk9";
    "1.13.0".hash = "sha256:0j4cz2y1r1aw79snkcf1pmicgzf8swbaf9ippz0vg99a572zqzri";
    "1.12.0".hash = "sha256:1ccfny1vwgmdl91kz5xlmhq4wz078xm4z5wpd0jy5rn890dx03wp";
    "1.11.0".hash = "sha256:06a71d196wd5k4wg7khwqb7j7ifr7garhwkd54s86i0j7d6nhl3c";
    "1.10.0".hash = "sha256:1b9m6pwxxyivw7rgx82gn5kmgv2mfv3h3y0mmjcjfypi8ydkrlbv";
    "1.9.0".hash = "sha256:0lid9zaazdi3d38l8042lczb02pw5m9wq0yysiilx891hgq2p81r";
    "1.8.0".hash = "sha256:07l40is389ih8bi525gpqs3qp4yb2kl11r9c8ynk1ifpjzpnabwp";
  };
  releaseRev = v: "mathcomp-${v}";

  # list of core mathcomp packages sorted by dependency order
  packages = {
    "boot" = [ ];
    "order" = [ "boot" ];
    "ssreflect" = [
      "boot"
      "order"
    ];
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
        else if package == "boot" then
          "cd boot || cd ssreflect" # before 2.5, boot didn't exist, make it behave as ssreflect
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
          propagatedBuildInputs = mathcomp-deps;

          buildFlags = lib.optional withDoc "doc";

          preBuild = ''
            if [[ -f etc/utils/ssrcoqdep ]]
            then patchShebangs etc/utils/ssrcoqdep
            fi
            if [[ -f etc/buildlibgraph ]]
            then patchShebangs etc/buildlibgraph
            fi
            # handle mathcomp < 2.4.0 which had an extra base mathcomp directory
            test -d mathcomp && cd mathcomp
            ${cdpkg}
          ''
          + lib.optionalString (package == "all") pkgallMake;

          useCoqifVersion = v: v != null && v != "dev" && lib.versions.isLt "2.4.0" v;

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
        lib.optionalAttrs (o.version != null && (o.version == "dev" || lib.versions.isGe "2.0.0" o.version))
          {
            propagatedBuildInputs = o.propagatedBuildInputs ++ [ hierarchy-builder ];
          }
      );
      patched-derivation2 = patched-derivation1.overrideAttrs (
        o:
        lib.optionalAttrs (o.version != null && o.version == "2.3.0") {
          propagatedBuildInputs = o.propagatedBuildInputs ++ [ stdlib ];
        }
      );
      # boot and order packages didn't exist before 2.5,
      # so make boot behave as ssreflect then (c.f., above)
      # and building nothing in order and ssreflect
      patched-derivation3 = patched-derivation2.overrideAttrs (
        o:
        lib.optionalAttrs
          (
            lib.elem package [
              "order"
              "ssreflect"
            ]
            && o.version != null
            && o.version != "dev"
            && lib.versions.isLt "2.5" o.version
          )
          {
            preBuild = "";
            buildPhase = "echo doing nothing";
            installPhase = "echo doing nothing";
          }
      );
      patched-derivation4 = patched-derivation3.overrideAttrs (
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
            propagatedBuildInputs =
              o.propagatedBuildInputs ++ lib.optional (micromega-plugin != null) micromega-plugin;
          }
      );
    in
    patched-derivation4;
in
mathcomp_ (if single then "single" else "all")
