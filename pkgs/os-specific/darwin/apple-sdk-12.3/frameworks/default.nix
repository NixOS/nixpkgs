{
  lib,
  stdenvNoCC,
  buildPackages,
  # macOS things
  callPackage,
  darwin-stubs,
}:

let
  inherit (darwin-stubs) version;
  fixup-frameworks = callPackage ./fixups.nix { };
  private-frameworks = callPackage ./private.nix { };
  public-frameworks = callPackage ./public.nix { };

  mkDepsRewrites =
    deps:
    let
      mergeRewrites = x: y: {
        prefix = lib.mergeAttrs (x.prefix or { }) (y.prefix or { });
        const = lib.mergeAttrs (x.const or { }) (y.const or { });
      };

      rewriteArgs =
        {
          prefix ? { },
          const ? { },
        }:
        lib.concatLists (
          (lib.mapAttrsToList (from: to: [
            "-p"
            "${from}:${to}"
          ]) prefix)
          ++ (lib.mapAttrsToList (from: to: [
            "-c"
            "${from}:${to}"
          ]) const)
        );

      rewrites =
        depList:
        lib.fold mergeRewrites { } (
          map (dep: dep.tbdRewrites) (lib.filter (dep: dep ? tbdRewrites) depList)
        );
    in
    lib.escapeShellArgs (rewriteArgs (rewrites (lib.attrValues deps)));

  mkFramework =
    {
      name,
      deps,
      private ? false,
    }:
    let
      standardFrameworkPath =
        name: private:
        "/System/Library/${lib.optionalString private "Private"}Frameworks/${name}.framework";

      self = stdenvNoCC.mkDerivation {
        pname = "apple-${lib.optionalString private "private-"}framework-${name}";
        inherit (darwin-stubs) version;

        # because we copy files from the system
        preferLocalBuild = true;

        dontUnpack = true;
        dontBuild = true;

        disallowedRequisites = [ darwin-stubs ];

        nativeBuildInputs = [ buildPackages.darwin.rewrite-tbd ];

        installPhase = ''
          mkdir -p $out/Library/Frameworks

          cp -r ${darwin-stubs}${standardFrameworkPath name private} $out/Library/Frameworks

          if [[ -d ${darwin-stubs}/usr/lib/swift/${name}.swiftmodule ]]; then
            mkdir -p $out/lib/swift
            cp -r -t $out/lib/swift \
              ${darwin-stubs}/usr/lib/swift/${name}.swiftmodule \
              ${darwin-stubs}/usr/lib/swift/libswift${name}.tbd
          fi

          # Fix and check tbd re-export references
          chmod u+w -R $out
          find $out -name '*.tbd' -type f | while IFS=$'\n' read tbd; do
            echo "Fixing re-exports in $tbd"
            rewrite-tbd \
              -p ${standardFrameworkPath name private}/:$out/Library/Frameworks/${name}.framework/ \
              -p /usr/lib/swift/:$out/lib/swift/ \
              ${mkDepsRewrites deps} \
              -r ${builtins.storeDir} \
              "$tbd"
          done
        '';

        propagatedBuildInputs = lib.attrValues deps;

        passthru.tbdRewrites.prefix."${standardFrameworkPath name private}/" = "${self}/Library/Frameworks/${name}.framework/";

        meta = with lib; {
          description = "Apple SDK framework ${name}";
          maintainers = [ ];
          platforms = platforms.darwin;
        };
      };
    in
    self;

  # Helper functions for creating framework derivations.
  framework =
    name: deps:
    mkFramework {
      inherit name deps;
      private = false;
    };

  # Helper functions for creating private framework derivations.
  privateFramework =
    name: deps:
    mkFramework {
      inherit name deps;
      private = true;
    };

  # Merge addToFrameworks into public-frameworks and remove elements of removeFromFrameworks.
  deps =
    let
      inherit (fixup-frameworks) addToFrameworks removeFromFrameworks;
      fixupDeps =
        name: deps:
        lib.pipe deps [
          # Add dependencies from addToFrameworks.
          (deps: lib.recursiveUpdate deps (addToFrameworks.${name} or { }))
          # Keep dependencies not in removeFromFrameworks.
          (lib.filterAttrs (depName: _: !(removeFromFrameworks.${name}.${depName} or false)))
        ];
    in
    lib.mapAttrs fixupDeps public-frameworks;

  # Create derivations and add private frameworks.
  bareFrameworks =
    (lib.mapAttrs framework deps) // (lib.mapAttrs privateFramework private-frameworks);
in
bareFrameworks // fixup-frameworks.overrideFrameworks bareFrameworks
