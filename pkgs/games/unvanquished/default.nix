{ lib
, stdenv
, fetchzip
, fetchFromGitHub
, fetchpatch
, SDL2
, buildFHSEnv
, cmake
, copyDesktopItems
, curl
, freetype
, gcc
, geoip
, glew
, gmp
, libGL
, libjpeg
, libogg
, libopus
, libpng
, libvorbis
, libwebp
, lua5
, makeDesktopItem
, ncurses
, nettle
, openal
, opusfile
, zlib
# to download assets
, aria2
, cacert
}:

let
  version = "0.54.0";
  binary-deps-version = "8";

  src = fetchFromGitHub {
    owner = "Unvanquished";
    repo = "Unvanquished";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-X2c6BHI4W6fOurLiBWIBZzJrZ+7RHMEwN8GJGz6e350=";
  };

  unvanquished-binary-deps = stdenv.mkDerivation rec {
    # DISCLAIMER: this is selected binary crap from the NaCl SDK
    name = "unvanquished-binary-deps";
    version = binary-deps-version;

    src = fetchzip {
      url = "https://dl.unvanquished.net/deps/linux-amd64-default_${version}.tar.xz ";
      sha256 = "sha256-6r9j0HRMDC/7i8f4f5bBK4NmwsTpSChHrRWwz0ENAZo=";
    };

    dontPatchELF = true;

    preFixup = ''
      # We are not using the autoPatchelfHook, because it would make
      # nacl_bootstrap_helper unable to load nacl_loader:
      # "nacl_loader: ELF file has unreasonable e_phnum=13"
      interpreter="$(< "$NIX_CC/nix-support/dynamic-linker")"
      for f in pnacl/bin/*; do
        if [ -f "$f" && -x "$f" ]; then
          echo "Patching $f"
          patchelf --set-interpreter "$interpreter" "$f"
        fi
      done
    '';

    preCheck = ''
      # check it links correctly
      pnacl/bin/clang -v
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -R ./* $out/

      runHook postInstall
    '';
  };

  libstdcpp-preload-for-unvanquished-nacl = stdenv.mkDerivation {
    name = "libstdcpp-preload-for-unvanquished-nacl";

    propagatedBuildInputs = [ gcc.cc.lib ];

    buildCommand = ''
      mkdir $out/etc -p
      echo ${gcc.cc.lib}/lib/libstdc++.so.6 > $out/etc/ld-nix.so.preload
    '';
  };

  fhsEnv = buildFHSEnv {
    name = "unvanquished-fhs-wrapper";

    targetPkgs = pkgs: [ libstdcpp-preload-for-unvanquished-nacl ];
  };

  wrapBinary = binary: wrappername: ''
    cat > $out/lib/${binary}-wrapper <<-EOT
    #!/bin/sh
    exec $out/lib/${binary} -pakpath ${unvanquished-assets} "\$@"
    EOT
    chmod +x $out/lib/${binary}-wrapper

    cat > $out/bin/${wrappername} <<-EOT
    #!/bin/sh
    exec ${fhsEnv}/bin/unvanquished-fhs-wrapper $out/lib/${binary}-wrapper "\$@"
    EOT
    chmod +x $out/bin/${wrappername}
  '';

  unvanquished-assets = stdenv.mkDerivation {
    pname = "unvanquished-assets";
    inherit version src;

    outputHash = "sha256-ua9Q5E5C4t8z/yNQp6qn1i9NNDAk4ohzvgpMbCBxb8Q=";
    outputHashMode = "recursive";

    nativeBuildInputs = [ aria2 cacert ];

    buildCommand = ''
      bash $src/download-paks --cache=$(pwd) --version=${version} $out
    '';
  };

# this really is the daemon game engine, the game itself is in the assets
in stdenv.mkDerivation rec {
  pname = "unvanquished";
  inherit version src binary-deps-version;

  preConfigure = ''
    TARGET="linux-amd64-default_${binary-deps-version}"
    mkdir daemon/external_deps/"$TARGET"
    cp -r ${unvanquished-binary-deps}/* daemon/external_deps/"$TARGET"/
    chmod +w -R daemon/external_deps/"$TARGET"/
  '';

  nativeBuildInputs = [
    cmake
    unvanquished-binary-deps
    copyDesktopItems
  ];

  buildInputs = [
    gmp
    libGL
    zlib
    ncurses
    geoip
    lua5
    nettle
    curl
    SDL2
    freetype
    glew
    openal
    libopus
    opusfile
    libogg
    libvorbis
    libjpeg
    libwebp
    libpng
  ];

  cmakeFlags = [
    "-DBUILD_CGAME=NO"
    "-DBUILD_SGAME=NO"
    "-DUSE_HARDENING=TRUE"
    "-DUSE_LTO=TRUE"
    "-DOpenGL_GL_PREFERENCE=LEGACY" # https://github.com/DaemonEngine/Daemon/issues/474
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "net.unvanquished.Unvanquished.desktop";
      desktopName = "Unvanquished";
      comment = "FPS/RTS Game - Aliens vs. Humans";
      icon = "unvanquished";
      exec = "unvanquished";
      categories = [ "Game" "ActionGame" "StrategyGame" ];
      prefersNonDefaultGPU = true;
    })
    (makeDesktopItem {
      name = "net.unvanquished.UnvanquishedProtocolHandler.desktop";
      desktopName = "Unvanquished (protocol handler)";
      noDisplay = true;
      exec = "unvanquished -connect %u";
      mimeTypes = [ "x-scheme-handler/unv" ];
      prefersNonDefaultGPU = true;
    })
  ];

  installPhase = ''
    runHook preInstall

    for f in daemon daemon-tty daemonded nacl_loader nacl_helper_bootstrap; do
      install -Dm0755 -t $out/lib/ $f
    done
    install -Dm0644 -t $out/lib/ irt_core-amd64.nexe

    mkdir $out/bin/
    ${wrapBinary "daemon"     "unvanquished"}
    ${wrapBinary "daemon-tty" "unvanquished-tty"}
    ${wrapBinary "daemonded"  "unvanquished-server"}

    for d in ${src}/dist/icons/*; do
      install -Dm0644 -t $out/share/icons/hicolor/$(basename $d)/apps/ $d/unvanquished.png
    done

    runHook postInstall
  '';

  meta = {
    homepage = "https://unvanquished.net/";
    downloadPage = "https://unvanquished.net/download/";
    description = "A fast paced, first person strategy game";
    # don't replace the following lib.licenses.zlib with just "zlib",
    # or you would end up with the package instead
    license = with lib.licenses; [
      mit gpl3Plus lib.licenses.zlib bsd3 # engine
      cc-by-sa-25 cc-by-sa-30 cc-by-30 cc-by-sa-40 cc0 # assets
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode  # unvanquished-binary-deps
    ];
    maintainers = with lib.maintainers; [ afontain ];
    platforms = [ "x86_64-linux" ];
  };
}
