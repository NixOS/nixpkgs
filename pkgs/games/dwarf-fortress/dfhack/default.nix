{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  ninja,
  writeScriptBin,
  perl,
  XMLLibXML,
  XMLLibXSLT,
  makeWrapper,
  zlib,
  enableStoneSense ? false,
  allegro5,
  libGLU,
  libGL,
  SDL,
  SDL2,
  coreutils,
  util-linux,
  ncurses,
  strace,
  binutils,
  gnused,
  dfVersion,
  dfVersions,
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

  release =
    if isAttrs dfVersion then
      dfVersion
    else if hasAttr dfVersion dfVersions.game.versions then
      (getAttr dfVersion dfVersions.game.versions).hack
    else
      throw "[DFHack] Unsupported Dwarf Fortress version: ${dfVersion}";

  inherit (release) version;
  isAtLeast50 = versionAtLeast version "50.0";
  needs50Patches = isAtLeast50 && (release.needsPatches or false);

  # revision of library/xml submodule
  inherit (release) xmlRev;

  arch =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      "64"
    else if stdenv.hostPlatform.system == "i686-linux" then
      "32"
    else
      throw "Unsupported architecture";

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
    tag = release.git.revision;
    hash = release.git.outputHash;
    fetchSubmodules = true;
  };

  patches =
    optional (versionOlder version "0.44.12-r3") (fetchpatch {
      name = "fix-stonesense.patch";
      url = "https://github.com/DFHack/stonesense/commit/f5be6fe5fb192f01ae4551ed9217e97fd7f6a0ae.patch";
      extraPrefix = "plugins/stonesense/";
      stripLen = 1;
      hash = "sha256-wje6Mkct29eyMOcJnbdefwBOLJko/s4JcJe52ojuW+8=";
    })
    ++ optional (versionOlder version "0.47.04-r1") (fetchpatch {
      name = "fix-protobuf.patch";
      url = "https://github.com/DFHack/dfhack/commit/7bdf958518d2892ee89a7173224a069c4a2190d8.patch";
      hash = "sha256-p+mKhmYbnhWKNiGPMjbYO505Gcg634n0nudqH0NX3KY=";
    })
    ++ optional needs50Patches (fetchpatch {
      name = "use-system-sdl2.patch";
      url = "https://github.com/DFHack/dfhack/commit/734fb730d72e53ebe67f4a041a24dd7c50307ee3.patch";
      hash = "sha256-uLX0gdVSzKEVibyUc1UxcQzdYkRm6D8DF+1eSOxM+qU=";
    })
    ++ optional needs50Patches (fetchpatch {
      name = "rename-lerp.patch";
      url = "https://github.com/DFHack/dfhack/commit/389dcf5cfcdb8bfb8deeb05fa5756c9f4f5709d1.patch";
      hash = "sha256-QuDtGURhP+nM+x+8GIKO5LrMcmBkl9JSHHIeqzqGIPQ=";
    })
    # Newer versions use SDL_GetBasePath and SDL_GetPrefPath with a Windows-esque directory
    # that mismatches where we have historically stored data in nixpkgs:
    # https://github.com/libsdl-org/SDL/blob/release-2.24.x/src/filesystem/unix/SDL_sysfilesystem.c#L136
    # Use SDL_GetPrefPath since this takes XDG_DATA_HOME into account (which is correct).
    ++ optional (versionAtLeast version "52.02-r2") ./use-df-linux-dir.patch;

  # gcc 11 fix
  CXXFLAGS = optionalString (versionOlder version "0.47.05-r3") "-fpermissive";

  nativeBuildInputs = [
    cmake
    ninja
    perl
    XMLLibXML
    XMLLibXSLT
    makeWrapper
    fakegit
  ];

  # We don't use system libraries because dfhack needs old C++ ABI.
  buildInputs = [
    zlib
  ]
  ++ optional isAtLeast50 SDL2
  ++ optional (!isAtLeast50) SDL
  ++ optionals enableStoneSense [
    allegro5
    libGLU
    libGL
  ];

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
  ]
  ++ optionals enableStoneSense [
    "-DBUILD_STONESENSE=ON"
    "-DSTONESENSE_INTERNAL_SO=OFF"
  ];

  NIX_CFLAGS_COMPILE = [
    "-Wno-error=deprecated-enum-enum-conversion"
  ]
  ++ optionals (versionOlder version "0.47") [ "-fpermissive" ];

  preFixup = ''
    # Wrap dfhack scripts.
    if [ -f $out/dfhack ]; then
      wrapProgram $out/dfhack \
        --inherit-argv0 \
        --set-default SteamAppId 0 \
        --set-default DFHACK_NO_RENAME_LIBSTDCXX 1 \
        --suffix PATH : ${
          lib.makeBinPath [
            coreutils
            util-linux
            strace
            gnused
            binutils
            ncurses
          ]
        }
    fi

    if [ -f $out/dfhack-run ]; then
      wrapProgram $out/dfhack-run \
        --inherit-argv0 \
        --suffix PATH : ${
          lib.makeBinPath [
            coreutils
          ]
        }
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
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    maintainers = with maintainers; [
      robbinch
      a1russell
      numinit
      ncfavier
    ];
  };
}
