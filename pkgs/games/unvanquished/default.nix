{ lib, stdenv, fetchzip, fetchFromGitHub, buildFHSUserEnv, makeDesktopItem
, copyDesktopItems, gcc, cmake, gmp , libGL, zlib, ncurses, geoip, lua5
, nettle, curl, SDL2, freetype, glew , openal, libopus, opusfile, libogg
, libvorbis, libjpeg, libwebp, libpng
, cacert, aria2 # to download assets
}:

let
  version = "0.52.1";
  binary-deps-version = "5";

  src = fetchFromGitHub {
    owner = "Unvanquished";
    repo = "Unvanquished";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "1fiqn9f6nsh4cfjy7gfsv950hphwi9ca0ddgsjvn77g7yc0arp6c";
  };

  unvanquished-binary-deps = stdenv.mkDerivation rec {
    # DISCLAIMER: this is selected binary crap from the NaCl SDK
    name = "unvanquished-binary-deps";
    version = binary-deps-version;
    src = fetchzip {
      url = "https://dl.unvanquished.net/deps/linux64-${version}.tar.bz2";
      sha256 = "08bpyavbh5lmyprvqqi59gnm8s1fjmlk9f1785wlv7f52d9f9z1p";
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
    preCheck = "pnacl/bin/clang -v"; # check it links correctly
    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -R ./* $out/

      runHook postInstall
    '';
  };

  libstdcpp-preload-for-unvanquished-nacl = stdenv.mkDerivation {
    name = "libstdcpp-preload-for-unvanquished-nacl";
    buildCommand = ''
      mkdir $out/etc -p
      echo ${gcc.cc.lib}/lib/libstdc++.so.6 > $out/etc/ld-nix.so.preload
    '';
    propagatedBuildInputs = [ gcc.cc.lib ];
  };

  fhsEnv = buildFHSUserEnv {
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

    outputHash = "sha256:084jdisb48xyk9agjifn0nlnsdnjgg32si8zd1khsywd0kffplzx";
    outputHashMode = "recursive";
    nativeBuildInputs = [ aria2 cacert ];
    buildCommand = "bash $src/download-paks --cache=$(pwd) --version=${version} $out";
  };

# this really is the daemon game engine, the game itself is in the assets
in stdenv.mkDerivation rec {
  pname = "unvanquished";
  inherit version src binary-deps-version;

  preConfigure = ''
    mkdir daemon/external_deps/linux64-${binary-deps-version}/
    cp -r ${unvanquished-binary-deps}/* daemon/external_deps/linux64-${binary-deps-version}/
    chmod +w -R daemon/external_deps/linux64-${binary-deps-version}/
  '';

  nativeBuildInputs = [ cmake unvanquished-binary-deps copyDesktopItems ];
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
      terminal = false;
      exec = "unvanquished";
      categories = "Game;ActionGame;StrategyGame;";
      # May or may not work
      prefersNonDefaultGPU = true;
      fileValidation = false; # it doesn't like PrefersNonDefaultGPU
      # yes, PrefersNonDefaultGPU is standard:
      # https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html
    })
    (makeDesktopItem {
      name = "net.unvanquished.UnvanquishedProtocolHandler.desktop";
      desktopName = "Unvanquished (protocol handler)";
      noDisplay = true;
      terminal = false;
      exec = "unvanquished -connect %u";
      mimeType = "x-scheme-handler/unv";
      # May or may not work
      prefersNonDefaultGPU = true;
      fileValidation = false; # it doesn't like PrefersNonDefaultGPU
    })
  ];

  installPhase = ''
    runHook preInstall

    for f in daemon daemon-tty daemonded nacl_loader nacl_helper_bootstrap; do
      install -Dm0755 -t $out/lib/ $f
    done
    install -Dm0644 -t $out/lib/ irt_core-x86_64.nexe

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
    platforms = [ "x86_64-linux" ];
    homepage = "https://unvanquished.net/";
    downloadPage = "https://unvanquished.net/download/";
    description = "A fast paced, first person strategy game";
    maintainers = with lib.maintainers; [ afontain ];
    # don't replace the following lib.licenses.zlib with just "zlib",
    # or you would end up with the package instead
    license = with lib.licenses; [
      mit gpl3Plus lib.licenses.zlib bsd3 # engine
      cc-by-sa-25 cc-by-sa-30 cc-by-30 cc-by-sa-40 cc0 # assets
    ];
  };
}
