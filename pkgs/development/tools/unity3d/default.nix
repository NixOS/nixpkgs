{ stdenv, lib, fetchurl, makeWrapper, file, getopt
, gtk2, gdk_pixbuf, glib, libGL, libGLU, nss, nspr, udev, tbb
, alsaLib, GConf, cups, libcap, fontconfig, freetype, pango
, cairo, dbus, expat, zlib, libpng12, nodejs, gnutar, gcc, gcc_32bit
, libX11, libXcursor, libXdamage, libXfixes, libXrender, libXi
, libXcomposite, libXext, libXrandr, libXtst, libSM, libICE, libxcb, chromium
}:

let
  libPath64 = lib.makeLibraryPath [
    gcc.cc gtk2 gdk_pixbuf glib libGL libGLU nss nspr
    alsaLib GConf cups libcap fontconfig freetype pango
    cairo dbus expat zlib libpng12 udev tbb
    libX11 libXcursor libXdamage libXfixes libXrender libXi
    libXcomposite libXext libXrandr libXtst libSM libICE libxcb
  ];
  libPath32 = lib.makeLibraryPath [ gcc_32bit.cc ];
  binPath = lib.makeBinPath [ nodejs gnutar ];

  ver = "2017.4.10";
  build = "f1";

in stdenv.mkDerivation rec {
  name = "unity-editor-${version}";
  version = "${ver}x${build}";

  src = fetchurl {
    url = "https://beta.unity3d.com/download/14396d76537e/LinuxEditorInstaller/Unity.tar.xz";
    sha256 = "e1b4fe41c0ff793f7a9146c49a8eca8c71d30abdfa3e81922bd69699810b3f67";
  };

  nosuidLib = ./unity-nosuid.c;

  nativeBuildInputs = [ makeWrapper file getopt ];

  outputs = [ "out" ];

  sourceRoot = ".";

  buildPhase = ''
    cd Editor

    $CC -fPIC -shared -o libunity-nosuid.so $nosuidLib -ldl
    strip libunity-nosuid.so

    cd ..
  '';

  installPhase = ''
    unitydir="$out/opt/Unity/Editor"
    mkdir -p $unitydir
    mv Editor/* $unitydir
    ln -sf /run/wrappers/bin/${chromium.sandboxExecutableName} $unitydir/chrome-sandbox

    mkdir -p $out/bin
    makeWrapper $unitydir/Unity $out/bin/unity-editor \
      --prefix LD_PRELOAD : "$unitydir/libunity-nosuid.so" \
      --prefix PATH : "${binPath}"
  '';

  preFixup = ''
    patchFile() {
      ftype="$(file -b "$1")"
      if [[ "$ftype" =~ LSB\ .*dynamically\ linked ]]; then
        if [[ "$ftype" =~ 32-bit ]]; then
          rpath="${libPath32}"
          intp="$(cat $NIX_CC/nix-support/dynamic-linker-m32)"
        else
          rpath="${libPath64}"
          intp="$(cat $NIX_CC/nix-support/dynamic-linker)"
        fi

        # Save origin-relative parts of rpath.
        originRpath="$(patchelf --print-rpath "$1" | sed "s/:/\n/g" | grep "^\$ORIGIN" | paste -sd ":" - || echo "")"
        rpath="$originRpath:$rpath"

        patchelf --set-rpath "$rpath" "$1"
        patchelf --set-interpreter "$intp" "$1" 2> /dev/null || true
      fi
    }

    upm_linux=$unitydir/Data/Resources/Upm/upm-linux

    orig_size=$(stat --printf=%s $upm_linux)

    # Exclude PlaybackEngines to build something that can be run on FHS-compliant Linuxes
    find $unitydir -name PlaybackEngines -prune -o -type f -print | while read path; do
      patchFile "$path"
    done

    new_size=$(stat --printf=%s $upm_linux)

    ###### zeit-pkg fixing starts here.
    # we're replacing plaintext js code that looks like
    # PAYLOAD_POSITION = '1234                  ' | 0
    # [...]
    # PRELUDE_POSITION = '1234                  ' | 0
    # ^-----20-chars-----^^------22-chars------^
    # ^-- grep points here
    #
    # var_* are as described above
    # shift_by seems to be safe so long as all patchelf adjustments occur 
    # before any locations pointed to by hardcoded offsets

    var_skip=20
    var_select=22
    shift_by=$(expr $new_size - $orig_size)

    function fix_offset {
      # $1 = name of variable to adjust
      location=$(grep -obUam1 "$1" $upm_linux | cut -d: -f1)
      location=$(expr $location + $var_skip)
      value=$(dd if=$upm_linux iflag=count_bytes,skip_bytes skip=$location \
                 bs=1 count=$var_select status=none)
      value=$(expr $shift_by + $value)
      echo -n $value | dd of=$upm_linux bs=1 seek=$location conv=notrunc
    }

    fix_offset PAYLOAD_POSITION
    fix_offset PRELUDE_POSITION
  '';

  dontStrip = true;
  dontPatchELF = true;

  meta = with stdenv.lib; {
    homepage = https://unity3d.com/;
    description = "Game development tool";
    longDescription = ''
      Popular development platform for creating 2D and 3D multiplatform games
      and interactive experiences.
    '';
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ jb55 ];
  };
}
