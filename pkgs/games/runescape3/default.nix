{ stdenv, buildFHSUserEnv, dpkg, glibc, gcc-unwrapped, autoPatchelfHook, fetchurl, wrapGAppsHook
  , xlibs, gnome2, xorg
  , libSM, libXxf86vm, libX11, glib, pango, gdk_pixbuf, cairo, gtk2-x11, zlib, libcap_progs, openssl, openssl_1_0_2
  , libpulseaudio
  , SDL2, xorg_sys_opengl, libGL
}:
let

  # Please keep the version x.y.0.z and do not update to x.y.76.z because the
  # source of the latter disappears much faster.
  version = "2.2.7";

  src = fetchurl {
    url = "https://content.runescape.com/downloads/ubuntu/pool/non-free/r/runescape-launcher/runescape-launcher_2.2.7_amd64.deb";
    sha256 = "0m5ydk7aynkdaxifh8pwn1ckanibnf50i4p3vv2159cqpzpf6wgc";
  };

  runescape = stdenv.mkDerivation {
    # name = "runescape-launcher-${version}";
    name = "runescape-launcher";
    system = "x86_64-linux";

    inherit src;

    # Required for compilation
    nativeBuildInputs = [
      autoPatchelfHook # Automatically setup the loader, and do the magic
      wrapGAppsHook
      dpkg
    ];

    # Required at running time
    buildInputs = [
      glibc
      gcc-unwrapped
      libSM
      libXxf86vm
      libX11
      glib
      pango
      gdk_pixbuf
      cairo
      gtk2-x11
      zlib
      libcap_progs
      openssl
    ];

    runtimeDependencies = [
      libpulseaudio.out

      libGL.out
      SDL2.out
      xorg_sys_opengl.out
      openssl.out
      zlib.out
    ];

    unpackPhase = "true";

    preBuildPhase = ''
      export DH_VERBOSE=1
    '';

    envVarsWithXmodifiers = ''
      export MESA_GLSL_CACHE_DIR=~/Jagex
      export GDK_SCALE=2
      unset XMODIFIERS
    '';

    # setcap cap_setfcap+ep /usr/share/games/runescape-launcher/runescape 
    # Extract and copy executable in $out/bin
    installPhase = ''
      mkdir -p $out/bin $out/share
      dpkg -x $src $out

      substituteInPlace $out/usr/bin/runescape-launcher \
        --replace "/bin/sh" "/usr/bin/env sh" \
        --replace "unset XMODIFIERS" "$envVarsWithXmodifiers" \
        --replace "/usr/share/games/runescape-launcher/runescape" "$out/share/games/runescape-launcher/runescape"

      cp -r $out/usr/bin $out/
      cp -r $out/usr/share $out/

      rm -rf $out/usr
    '';


    meta = with stdenv.lib; {
      description = "Launcher for RuneScape 3, the current main RuneScape";
      homepage = "https://www.runescape.com/";
      license = licenses.unfree;
      maintainers = with stdenv.lib.maintainers; [ grburst ];
      platforms = [ "x86_64-linux" ];
    };
  };

in

  /*
  * We can patch the runescape launcher, but it downloads a client at runtime and checks it for changes.
  * For that we need use a buildFHSUserEnv.
  */
  buildFHSUserEnv {
   name = "RuneScape";
   targetPkgs = pkgs: [
     runescape
     dpkg glibc gcc-unwrapped
     libSM libXxf86vm libX11 glib pango gdk_pixbuf cairo gtk2-x11 zlib libcap_progs openssl openssl_1_0_2
     libpulseaudio
     xorg.libX11
     SDL2 xorg_sys_opengl libGL
   ];
   multiPkgs = pkgs: [ libGL ];
   runScript = "runescape-launcher";
}

# rs2client

# missing libs:
# > ldd rs2client | grep 'not found' | cut -d '=' -f1
# => libSDL2-2.0.so.0 libGL.so.1 libcrypto.so.1.1 libssl.so.1.1 libz.so.1 

# get missing libs:
# > for dep in libSDL2-2.0.so.0 libGL.so.1 libcrypto.so.1.1 libssl.so.1.1 libz.so.1 ; do echo "~ $dep ~"; nix-locate -1 -w lib/${dep}; echo " "; done
# => SDL2 xorg_sys_opengl libglvnd openssl zlib

# library paths
# > run nix repl '<nixpkgs>'
# >> with pkgs; lib.makeLibraryPath [ SDL2 xorg_sys_opengl libglvnd openssl zlib ]

# patch
# > nix-shell -p binutils stdenv wget dpkg nix-index stdenv.cc
# >> patchelf  --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath "/nix/store/h4bjldjkw2mkmw478vbl3c4d8bg6zhfr-SDL2-2.0.12/lib:/nix/store/18wjma10bj945s84ign49386pixlsrhm-xorg-sys-opengl-3/lib:/nix/store/bnydnhhi4vib1f17han6bdjm8f08hjz2-libglvnd-1.2.0/lib:/nix/store/s54w52i1my3039krfvhyizwpbxcmiadi-openssl-1.1.1f/lib:/nix/store/hk87010wz87bqvg5az5vzpsxhq9bl9ky-zlib-1.2.11/lib" ~/Jagex/launcher/rs2client
