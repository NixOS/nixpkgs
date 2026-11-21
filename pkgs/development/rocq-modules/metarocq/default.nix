{
  lib,
  mkCoqDerivation,
  single ? false,
  coq,
  equations,
  ExtLib,
  stdlib,
  version ? null,
}@args:

let
  repo = "metarocq";
  owner = "MetaRocq";
  defaultVersion =
    let
      case = case: out: { inherit case out; };
    in
    lib.switch coq.coq-version [
      (case "9.2" "1.5.1-9.2")
      (case "9.1" "1.5.1-9.1")
      (case "9.0" "1.4-9.0.1")
    ] null;
  release = {
    "1.4-9.0".hash = "sha256-5QecDAMkvgfDPZ7/jDfnOgcE+Eb1LTAozP7nz6nkuxg=";
    "1.4-9.0.1".hash = "sha256-zMUd2A6EG0LYK3L9ABQvS/Et4MDpSmf3Pxd9+IPNYkI=";
    "1.4-9.1".hash = "sha256-v6jFvUavIzyb/e6ytAaZjxQLFM9uW9TDUB77yRO74eE=";
    "1.4.1-9.1".hash = "sha256-tzoAWX74lg7pArGVP11QBvDRKMvmGxXvrf3+1E3Y4DI=";
    "1.5.1-9.1".hash = "sha256-0iFnSzfbufn2XhJ8EPyWu3KIiHYwxfMVQa2KT6GSR7s=";
    "1.5.1-9.2".hash = "sha256-sinpbes0dEg2dGueu90ckY+qoyzeUS0uG6RrozHN86E=";
  };
  releaseRev = v: "v${v}";

  # list of core metarocq packages and their dependencies
  packages = {
    "utils" = [ ];
    "common" = [ "utils" ];
    "template" = [ "common" ];
    "pcuic" = [ "common" ];
    "safechecker" = [ "pcuic" ];
    "template-pcuic" = [
      "template"
      "pcuic"
    ];
    "erasure" = [
      "safechecker"
      "template-pcuic"
    ];
    "quotation" = [
      "template"
      "pcuic"
      "template-pcuic"
    ];
    "safechecker-plugin" = [
      "template-pcuic"
      "safechecker"
    ];
    "erasure-plugin" = [
      "template-pcuic"
      "erasure"
    ];
    "translations" = [ "template" ];
    "all" = [
      "safechecker-plugin"
      "erasure-plugin"
      "translations"
      "quotation"
    ];
  };

  template-pcuic = metarocq_ "template-pcuic";
  template-rocq = metarocq_ "template";

  metarocq_ =
    package:
    let
      metarocq-deps = lib.optionals (package != "single") (map metarocq_ packages.${package});
      pkgpath =
        if package == "single" then
          "./"
        else if package == "template" then
          "./template-rocq"
        else
          "./${package}";
      pname = if package == "all" then "metarocq" else "metarocq-${package}";
      pkgallMake = ''
        mkdir all
        echo "all:" > all/Makefile
        echo "install:" >> all/Makefile
      '';
      derivation = mkCoqDerivation (
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
          opam-name = "rocq-metarocq-" + package;

          mlPlugin = true;
          propagatedBuildInputs = [
            equations
            ExtLib
            stdlib
            coq.ocamlPackages.zarith
            coq.ocamlPackages.stdlib-shims
          ]
          ++ lib.optional (package == "template-rocq") coq
          ++ metarocq-deps;

          useDuneifVersion = v: v != null && (v == "dev" || lib.versions.isGt "1.5.1-9.2" v);

          meta = {
            homepage = "https://metarocq.github.io/";
            license = lib.licenses.mit;
            maintainers = with lib.maintainers; [ cohencyril ];
          };
        }
        // lib.optionalAttrs (package != "single") {
          passthru = lib.mapAttrs (package: deps: metarocq_ package) packages;
        }
      );
      patched-derivation1 = derivation.overrideAttrs (
        o:
        lib.optionalAttrs
          (o.version != null && o.version != "dev" && lib.versions.isLe "1.5.1-9.2" o.version)
          {
            patchPhase = ''
              patchShebangs ./configure.sh
              patchShebangs ./template-rocq/update_plugin.sh
              patchShebangs ./template-rocq/gen-src/to-lower.sh
              patchShebangs ./safechecker-plugin/clean_extraction.sh
              patchShebangs ./erasure-plugin/clean_extraction.sh
              echo "CAMLFLAGS+=-w -60 # Unused module" >> ./safechecker/Makefile.plugin.local
              sed -i -e 's/mv $i $newi;/mv $i tmp; mv tmp $newi;/' ./template-rocq/gen-src/to-lower.sh ./safechecker-plugin/clean_extraction.sh ./erasure-plugin/clean_extraction.sh
            '';
            configurePhase =
              lib.optionalString (package == "all") pkgallMake
              + ''
                touch ${pkgpath}/metarocq-config
              ''
              +
                lib.optionalString
                  (lib.elem package [
                    "erasure"
                    "template-pcuic"
                    "quotation"
                    "safechecker-plugin"
                    "erasure-plugin"
                    "translations"
                  ])
                  ''
                    echo  "-I ${template-rocq}/lib/coq/${coq.coq-version}/user-contrib/MetaRocq/Template/" > ${pkgpath}/metarocq-config
                  ''
              + lib.optionalString (package == "single") ''
                ./configure.sh local
              '';
            preBuild = ''
              cd ${pkgpath}
            '';
          }
      );
      # plugins are now built as part of safechecker and erasure by the dune config
      patched-derivation2 = patched-derivation1.overrideAttrs (
        o:
        lib.optionalAttrs
          (
            lib.elem package [
              "safechecker"
              "erasure"
            ]
            && o.version != null
            && (o.version == "dev" || lib.versions.isGt "1.5.1-9.2" o.version)
          )
          {
            propagatedBuildInputs = o.propagatedBuildInputs ++ [ template-pcuic ];
          }
      );
      patched-derivation3 = patched-derivation2.overrideAttrs (
        o:
        lib.optionalAttrs
          (
            lib.elem package [
              "safechecker-plugin"
              "erasure-plugin"
              "all"
            ]
            && o.version != null
            && (o.version == "dev" || lib.versions.isGt "1.5.1-9.2" o.version)
          )
          {
            configurePhase = ''
              echo no configuration
            '';
            buildPhase = ''
              echo building nothing
            '';
            installPhase = ''
              echo installing nothing
              # Make an output directory rather than a file, so this is more friendly to buildEnv
              mkdir $out
            '';
          }
      );
    in
    patched-derivation3;
in
metarocq_ (if single then "single" else "all")
