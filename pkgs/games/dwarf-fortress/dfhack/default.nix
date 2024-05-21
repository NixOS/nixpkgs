{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, cmake
, ninja
, writeScriptBin
, perl
, XMLLibXML
, XMLLibXSLT
, makeWrapper
, zlib
, enableStoneSense ? false
, allegro5
, libGLU
, libGL
, SDL
, SDL2
, coreutils
, util-linux
, ncurses
, strace
, binutils
, gnused
, dfVersion
}:

let
  inherit (lib)
    getAttr
    hasAttr
    isAttrs
    licenses
    maintainers
    optional
    optionals
    optionalString
    versionOlder
    versionAtLeast
    ;

  dfhack-releases = {
    "0.44.10" = {
      dfHackRelease = "0.44.10-r2";
      hash = "sha256-0RikMwFv/eJk26Hptnam6J97flekapQhjWvw3+HTfaU=";
      xmlRev = "321bd48b10c4c3f694cc801a7dee6be392c09b7b";
    };
    "0.44.11" = {
      dfHackRelease = "0.44.11-beta2.1";
      hash = "sha256-Yi/8BdoluickbcQQRbmuhcfrvrl02vf12MuHmh5m/Mk=";
      xmlRev = "f27ebae6aa8fb12c46217adec5a812cd49a905c8";
      prerelease = true;
    };
    "0.44.12" = {
      dfHackRelease = "0.44.12-r1";
      hash = "sha256-3j83wgRXbfcrwPRrJVHFGcLD+tXy1M3MR2dwIw2mA0g=";
      xmlRev = "23500e4e9bd1885365d0a2ef1746c321c1dd5094";
    };
    "0.47.02" = {
      dfHackRelease = "0.47.02-alpha0";
      hash = "sha256-ScrFcfyiimuLgEaFjN5DKKRaFuKfdJjaTlGDit/0j6Y=";
      xmlRev = "23500e4e9bd1885365d0a2ef1746c321c1dd509a";
      prerelease = true;
    };
    "0.47.04" = {
      dfHackRelease = "0.47.04-r5";
      hash = "sha256-0s+/LKbqsS/mrxKPDeniqykE5+Gy3ZzCa8yEDzMyssY=";
      xmlRev = "be0444cc165a1abff053d5893dc1f780f06526b7";
    };
    "0.47.05" = {
      dfHackRelease = "0.47.05-r7";
      hash = "sha256-vBKUTSjfCnalkBzfjaIKcxUuqsGGOTtoJC1RHJIDlNc=";
      xmlRev = "f5019a5c6f19ef05a28bd974c3e8668b78e6e2a4";
    };
    "50.10" = {
      dfHackRelease = "50.10-r1.1";
      hash = "sha256-k2j8G4kJ/RYE8W0YDOxcsRb5qjjn4El+rigf0v3AqZU=";
      xmlRev = "041493b221e0799c106abeac1f86df4535ab80d3";
      needsPatches = true;
    };
    "50.11" = {
      dfHackRelease = "50.11-r7";
      hash = "sha256-3KsFc0i4XkzoeRvcl5GUlx/fJB1HyqfZm+xL6T4oT/A=";
      xmlRev = "cca87907c1cbfcf4af957b0bea3a961a345b1581";
      needsPatches = true;
    };
    "50.12" = {
      dfHackRelease = "50.12-r3";
      hash = "sha256-2mO8DpNmZRCV7IRY0arf3SMvlO4Pxs61Kxfh3q3k3HU=";
      xmlRev = "980b1af13acc31660dce632f913c968f52e2b275";
    };
    "50.13" = {
      dfHackRelease = "50.13-r1.1";
      hash = "sha256-FiXanXflszTr4ogz+EoDAUxzE2U9ODeZIJJ1u6Xm4Mo=";
      xmlRev = "3507715fd07340de5a6c47064220f6e17343e5d5";
    };
  };

  release =
    if isAttrs dfVersion
    then dfVersion
    else if hasAttr dfVersion dfhack-releases
    then getAttr dfVersion dfhack-releases
    else throw "[DFHack] Unsupported Dwarf Fortress version: ${dfVersion}";

  version = release.dfHackRelease;
  isAtLeast50 = versionAtLeast version "50.0";
  needs50Patches = isAtLeast50 && (release.needsPatches or false);

  # revision of library/xml submodule
  xmlRev = release.xmlRev;

  arch =
    if stdenv.hostPlatform.system == "x86_64-linux" then "64"
    else if stdenv.hostPlatform.system == "i686-linux" then "32"
    else throw "Unsupported architecture";

  fakegit = writeScriptBin "git" ''
    #! ${stdenv.shell}
    if [ "$*" = "describe --tags --long" ]; then
      echo "${version}-unknown"
    elif [ "$*" = "describe --tags --abbrev=8 --long" ]; then
      echo "${version}-unknown"
    elif [ "$*" = "describe --tags --abbrev=8 --exact-match" ]; then
      echo "${version}"
    elif [ "$*" = "rev-parse HEAD" ]; then
      if [ "$(dirname "$(pwd)")" = "xml" ]; then
        echo "${xmlRev}"
      else
        echo "refs/tags/${version}"
      fi
    elif [ "$*" = "rev-parse HEAD:library/xml" ]; then
      echo "${xmlRev}"
    else
      exit 1
    fi
  '';
in
  stdenv.mkDerivation {
    pname = "dfhack";
    inherit version;

    # Beware of submodules
    src = fetchFromGitHub {
      owner = "DFHack";
      repo = "dfhack";
      rev = release.dfHackRelease;
      inherit (release) hash;
      fetchSubmodules = true;
    };

    patches = optional (versionOlder version "0.44.12-r3") (fetchpatch {
      name = "fix-stonesense.patch";
      url = "https://github.com/DFHack/stonesense/commit/f5be6fe5fb192f01ae4551ed9217e97fd7f6a0ae.patch";
      extraPrefix = "plugins/stonesense/";
      stripLen = 1;
      hash = "sha256-wje6Mkct29eyMOcJnbdefwBOLJko/s4JcJe52ojuW+8=";
    }) ++ optional (versionOlder version "0.47.04-r1") (fetchpatch {
      name = "fix-protobuf.patch";
      url = "https://github.com/DFHack/dfhack/commit/7bdf958518d2892ee89a7173224a069c4a2190d8.patch";
      hash = "sha256-p+mKhmYbnhWKNiGPMjbYO505Gcg634n0nudqH0NX3KY=";
    }) ++ optional needs50Patches (fetchpatch {
      name = "use-system-sdl2.patch";
      url = "https://github.com/DFHack/dfhack/commit/734fb730d72e53ebe67f4a041a24dd7c50307ee3.patch";
      hash = "sha256-uLX0gdVSzKEVibyUc1UxcQzdYkRm6D8DF+1eSOxM+qU=";
    }) ++ optional needs50Patches (fetchpatch {
      name = "rename-lerp.patch";
      url = "https://github.com/DFHack/dfhack/commit/389dcf5cfcdb8bfb8deeb05fa5756c9f4f5709d1.patch";
      hash = "sha256-QuDtGURhP+nM+x+8GIKO5LrMcmBkl9JSHHIeqzqGIPQ=";
    });

    # gcc 11 fix
    CXXFLAGS = optionalString (versionOlder version "0.47.05-r3") "-fpermissive";

    # As of
    # https://github.com/DFHack/dfhack/commit/56e43a0dde023c5a4595a22b29d800153b31e3c4,
    # dfhack gets its goodies from the directory above the Dwarf_Fortress
    # executable, which leads to stock Dwarf Fortress and not the built
    # environment where all the dfhack resources are symlinked to (typically
    # ~/.local/share/df_linux). This causes errors like `tweak is not a
    # recognized command` to be reported and dfhack to lose some of its
    # functionality.
    postPatch = ''
      sed -i 's@cached_path = path_string.*@cached_path = getenv("DF_DIR");@' library/Process-linux.cpp
    '';

    nativeBuildInputs = [ cmake ninja perl XMLLibXML XMLLibXSLT makeWrapper fakegit ];

    # We don't use system libraries because dfhack needs old C++ ABI.
    buildInputs = [ zlib ]
      ++ optional isAtLeast50 SDL2
      ++ optional (!isAtLeast50) SDL
      ++ optionals enableStoneSense [ allegro5 libGLU libGL ];

    preConfigure = ''
      # Trick the build system into believing we have .git.
      mkdir -p .git/modules/library/xml
      touch .git/index .git/modules/library/xml/index
    '';

    cmakeFlags = [
      # Race condition in `Generating codegen.out.xml and df/headers` that is fixed when using Ninja.
      "-GNinja"
      "-DDFHACK_BUILD_ARCH=${arch}"

      # Don't download anything.
      "-DDOWNLOAD_RUBY=OFF"
      "-DUSE_SYSTEM_SDL2=ON"

      # Ruby support with dfhack is very spotty and was removed in version 50.
      "-DBUILD_RUBY=OFF"
    ] ++ optionals enableStoneSense [ "-DBUILD_STONESENSE=ON" "-DSTONESENSE_INTERNAL_SO=OFF" ];

    NIX_CFLAGS_COMPILE = [ "-Wno-error=deprecated-enum-enum-conversion" ]
      ++ optionals (versionOlder version "0.47") [ "-fpermissive" ];

    preFixup = ''
      # Wrap dfhack scripts.
      if [ -f $out/dfhack ]; then
        wrapProgram $out/dfhack \
          --inherit-argv0 \
          --set-default SteamAppId 0 \
          --set-default DFHACK_NO_RENAME_LIBSTDCXX 1 \
          --suffix PATH : ${lib.makeBinPath [
            coreutils util-linux strace gnused binutils ncurses
          ]}
      fi

      if [ -f $out/dfhack-run ]; then
        wrapProgram $out/dfhack-run \
          --inherit-argv0 \
          --suffix PATH : ${lib.makeBinPath [
            coreutils
          ]}
      fi

      # Create a dfhackrc that changes to the correct home directory.
      cat <<EOF > $out/.dfhackrc
      #!/usr/bin/env bash
      # nixpkgs dfhackrc helper
      if [ -d "\$NIXPKGS_DF_HOME" ]; then
        cd "\$NIXPKGS_DF_HOME"
        DF_DIR="\$NIXPKGS_DF_HOME"
      fi
      export DF_DIR
      EOF
    '';

    passthru = {
      inherit dfVersion;
    };

    meta = {
      description = "Memory hacking library for Dwarf Fortress and a set of tools that use it";
      homepage = "https://github.com/DFHack/dfhack/";
      license = licenses.zlib;
      platforms = [ "x86_64-linux" "i686-linux" ];
      maintainers = with maintainers; [ robbinch a1russell abbradar numinit ncfavier ];
    };
  }
