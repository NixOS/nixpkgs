{
  buildPackages,
  lib,
  stdenvNoCC,
  # macOS things
  callPackage,
  MacOSX-SDK,
}:
let
  inherit (MacOSX-SDK) version;
  fixup-frameworks = callPackage (./. + "/${version}/fixups.nix") {};
  private-frameworks = callPackage (./. + "/${version}/private.nix") {};
  public-frameworks = callPackage (./. + "/${version}/public.nix") {};

  mkDepsRewrites = deps: let
    mergeRewrites = x: y: {
      prefix = lib.mergeAttrs (x.prefix or {}) (y.prefix or {});
      const = lib.mergeAttrs (x.const or {}) (y.const or {});
    };

    rewriteArgs = {
      prefix ? {},
      const ? {},
    }:
      lib.concatLists (
        (lib.mapAttrsToList (from: to: ["-p" "${from}:${to}"]) prefix)
        ++ (lib.mapAttrsToList (from: to: ["-c" "${from}:${to}"]) const)
      );

    rewrites = depList:
      lib.fold mergeRewrites {}
      (map (dep: dep.tbdRewrites)
        (lib.filter (dep: dep ? tbdRewrites) depList));
  in
    lib.escapeShellArgs (rewriteArgs (rewrites (builtins.attrValues deps)));

  mkFramework = {
    name,
    deps,
    private ? false,
  }: let
    standardFrameworkPath = name: private: "/System/Library/${lib.optionalString private "Private"}Frameworks/${name}.framework";

    self = stdenvNoCC.mkDerivation {
      inherit (MacOSX-SDK) version;
      pname = "apple-${lib.optionalString private "private-"}framework-${name}";

      dontUnpack = true;

      # because we copy files from the system
      preferLocalBuild = true;

      disallowedRequisites = [MacOSX-SDK];

      nativeBuildInputs = [buildPackages.darwin.rewrite-tbd];

      installPhase = ''
        mkdir -p $out/Library/Frameworks

        cp -r ${MacOSX-SDK}${standardFrameworkPath name private} $out/Library/Frameworks

        if [[ -d ${MacOSX-SDK}/usr/lib/swift/${name}.swiftmodule ]]; then
          mkdir -p $out/lib/swift
          cp -r -t $out/lib/swift \
            ${MacOSX-SDK}/usr/lib/swift/${name}.swiftmodule \
            ${MacOSX-SDK}/usr/lib/swift/libswift${name}.tbd
        fi

        # Fix and check tbd re-export references
        chmod u+w -R $out
        find $out -name '*.tbd' -type f | while read tbd; do
          echo "Fixing re-exports in $tbd"
          rewrite-tbd \
            -p ${standardFrameworkPath name private}/:$out/Library/Frameworks/${name}.framework/ \
            -p /usr/lib/swift/:$out/lib/swift/ \
            ${mkDepsRewrites deps} \
            -r ${builtins.storeDir} \
            "$tbd"
        done
      '';

      propagatedBuildInputs = builtins.attrValues deps;

      passthru.tbdRewrites.prefix."${standardFrameworkPath name private}/" = "${self}/Library/Frameworks/${name}.framework/";

      meta = with lib; {
        description = "Apple SDK framework ${name}";
        maintainers = with maintainers; [copumpkin];
        platforms = platforms.darwin;
      };
    };
  in
    self;

  # Helper functions for creating framework derivations.
  framework = name: deps:
    mkFramework {
      inherit name deps;
      private = false;
    };

  # Helper functions for creating private framework derivations.
  privateFramework = name: deps:
    mkFramework {
      inherit name deps;
      private = true;
    };

  # Merge addToFrameworks into public-frameworks and remove elements of removeFromFrameworks.
  deps = let
    inherit (fixup-frameworks) addToFrameworks removeFromFrameworks;
    fixupDeps = name: deps:
      lib.pipe deps [
        # Add dependencies from addToFrameworks.
        (deps: lib.recursiveUpdate deps (addToFrameworks.${name} or {}))
        # Keep dependencies not in removeFromFrameworks.
        (lib.filterAttrs (depName: _: ! (removeFromFrameworks.${name}.${depName} or false)))
      ];
  in
    lib.mapAttrs fixupDeps public-frameworks;

  # Create derivations and add private frameworks.
  bareFrameworks =
    (lib.mapAttrs framework deps)
    // (lib.mapAttrs privateFramework private-frameworks);
in
  bareFrameworks // fixup-frameworks.overrideFrameworks bareFrameworks
