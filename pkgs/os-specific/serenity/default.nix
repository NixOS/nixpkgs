{ lib
, stdenv
, stdenvNoCC
, callPackage
, buildPackages
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

  serenity-headers = callPackage ./headers.nix { inherit src version; };

  mkLibrary = pname: deps:
    stdenvNoCC.mkDerivation {
      inherit pname version;

      dontUnpack = true;

      nativeBuildInputs = [
        patchelf
      ];

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

      preFixup = ''
        for i in $out/lib/*.so*; do
          echo "setting RPATH of $i"
          patchelf  --set-rpath "${lib.makeLibraryPath (builtins.attrValues deps)}" $i || true
        done
      '';

      meta = with lib; {
        description = "${pname}. A library for SerenityOS";
        homepage = "https://serenityos.org";
        license = licenses.bsd2;
        maintainers = teams.serenity.members;
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

    nativeBuildInputs = [ patchelf ];

    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/lib
      cp -r ${rootfs}/lib/Loader.* $out/lib
    '';

    preFixup = ''
      patchelf --set-rpath "" $out/lib/Loader.so
    '';

    meta = with lib; {
      description = "Dynamic loader for SerenityOS";
      homepage = "https://serenityos.org";
      license = licenses.bsd2;
      maintainers = teams.serenity.members;
      platforms = platforms.serenity;
    };
  };
in
libraries // overrides libraries // {
  inherit DynamicLoader rootfs serenity-headers;
}
