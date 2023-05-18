{ lib
, stdenv
, stdenvNoCC
, runCommand
, callPackage
, buildPackages
, pkgsBuildBuild
, patchelf
}:
let
  rev = "0bbd9040efbe97850a18a49a9cea25498d727f13";

  version = "unstable-2023-05-18";

  # Fetch Serenity source and patch shebangs
  src = buildPackages.stdenvNoCC.mkDerivation {
    pname = "serenity-src";
    inherit version;

    src = buildPackages.fetchFromGitHub {
      owner = "SerenityOS";
      repo = "serenity";
      sha256 = "ene8HLOtch4uGZ4nv61woDpRegRm9eLUl3n4V5jt0tA=";
      inherit rev;
    };

    installPhase = ''
      cp -r . $out
    '';

    dontPatchELF = true;
  };

  rootfs = callPackage ./rootfs.nix { inherit stdenv src version; };

  mkLibrary = pname: deps:
    stdenvNoCC.mkDerivation {
      inherit pname version;

      # FIXME: rpath is not rewritten to use dependency derivations
      buildInputs = builtins.attrValues deps;

      dontUnpack = true;
      installPhase = ''
        mkdir -p $out/lib $out/include
        find ${rootfs}/lib \
          -iname '${pname}.*' \
          -exec cp {} $out/lib \;

        includes="${rootfs}/include/${pname}"
        if [ -d $includes ] ; then
          cp -r $includes $out/include
        fi
      '';

      meta = with lib; {
        description = "${pname}. A library for SerenityOS";
        homepage = "https://serenityos.org";
        license = licenses.bsd2;
        maintainers = with maintainers; [ emilytrau ];
        platforms = platforms.serenity;
      };
    };

  libraries =
    let
      generatedDeps = import ./libraries.nix { inherit libraries; };
    in
    lib.mapAttrs mkLibrary generatedDeps;

  overrides = super: {
    LibC = super.LibC.overrideAttrs (old: rec {
      installPhase = ''
        mkdir -p $out/lib
        cp ${rootfs}/lib/{crt*,libc.*,libdl.*,libm.*,libpthread.*,libssp.*} $out/lib
        cp -r ${serenity-headers}/include $out/include
      '';

      meta = old.meta // {
        description = "Compatible C Library for SerenityOS";
      };
    });
  };

  DynamicLoader = stdenvNoCC.mkDerivation {
    pname = "DynamicLoader";
    inherit version;

    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/lib
      cp -r ${rootfs}/lib/Loader.* $out/lib
    '';

    meta = with lib; {
      description = "Dynamic loader for SerenityOS";
      homepage = "https://serenityos.org";
      license = licenses.bsd2;
      maintainers = with maintainers; [ emilytrau ];
      platforms = platforms.serenity;
    };
  };

  serenity-headers = runCommand "serenity-headers" {}
    ''
      cd ${src}
      FILES=$(find \
              AK \
              Kernel/API \
              Kernel/Arch \
              Userland/Libraries/LibC \
              -name '*.h' -print)
      for header in $FILES; do
        target=$(echo "$header" | sed -e "s|Userland/Libraries/LibC||")
        mkdir -p "$(dirname "$out/include/$target")"
        cp "$header" "$out/include/$target"
      done
    '';
in
libraries // overrides libraries // {
  inherit DynamicLoader rootfs serenity-headers;
}
