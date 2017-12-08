{ stdenv, lib, buildPackages, fetchurl, fetchpatch
, enableStatic ? false
, enableMinimal ? false
, useMusl ? false, musl
, extraConfig ? ""
, buildPlatform, hostPlatform
}:

let
  configParser = ''
    function parseconfig {
        while read LINE; do
            NAME=`echo "$LINE" | cut -d \  -f 1`
            OPTION=`echo "$LINE" | cut -d \  -f 2`

            if ! [[ "$NAME" =~ ^CONFIG_ ]]; then continue; fi

            echo "parseconfig: removing $NAME"
            sed -i /$NAME'\(=\| \)'/d .config

            echo "parseconfig: setting $NAME=$OPTION"
            echo "$NAME=$OPTION" >> .config
        done
    }
  '';

in

stdenv.mkDerivation rec {
  name = "busybox-1.27.2";

  # Note to whoever is updating busybox: please verify that:
  # nix-build pkgs/stdenv/linux/make-bootstrap-tools.nix -A test
  # still builds after the update.
  src = fetchurl {
    url = "http://busybox.net/downloads/${name}.tar.bz2";
    sha256 = "1pv3vs2w4l2wnw5qb0rkbpvjjdd1fwjv87miavqq0r0ynqbfajwx";
  };

  hardeningDisable = [ "format" ] ++ lib.optionals enableStatic [ "fortify" ];

  patches = [
    ./busybox-in-store.patch
    (fetchpatch {
      name = "CVE-2017-15873.patch";
      url = "https://git.busybox.net/busybox/patch/?id=0402cb32df015d9372578e3db27db47b33d5c7b0";
      sha256 = "1s3xqifd0dww19mbnzrks0i1az0qwd884sxjzrx33d6a9jxv4dzn";
    })
    (fetchpatch {
      name = "CVE-2017-15874.patch";
      url = "https://git.busybox.net/busybox/patch/?id=9ac42c500586fa5f10a1f6d22c3f797df11b1f6b";
      sha256 = "0169p4ylz9zd14ghhb39yfjvbdca2kb21pphylfh9ny7i484ahql";
    })
    (fetchpatch {
      name = "CVE-2017-16544.patch";
      url = "https://git.busybox.net/busybox/patch/?id=c3797d40a1c57352192c6106cc0f435e7d9c11e8";
      sha256 = "1q3lkc4xczxrzhz73x2r0w7kmd6y33zhcnz3478nk5xi0qr66mcy";
    })
  ];

  configurePhase = ''
    export KCONFIG_NOTIMESTAMP=1
    make ${if enableMinimal then "allnoconfig" else "defconfig"}

    ${configParser}

    cat << EOF | parseconfig

    CONFIG_PREFIX "$out"
    CONFIG_INSTALL_NO_USR y

    CONFIG_LFS y

    ${lib.optionalString enableStatic ''
      CONFIG_STATIC y
    ''}

    # Use the external mount.cifs program.
    CONFIG_FEATURE_MOUNT_CIFS n
    CONFIG_FEATURE_MOUNT_HELPERS y

    # Set paths for console fonts.
    CONFIG_DEFAULT_SETFONT_DIR "/etc/kbd"

    ${extraConfig}
    CONFIG_CROSS_COMPILER_PREFIX "${stdenv.cc.prefix}"
    EOF

    make oldconfig

    runHook postConfigure
  '';

  postConfigure = lib.optionalString useMusl ''
    makeFlagsArray+=("CC=${stdenv.cc.prefix}gcc -isystem ${musl}/include -B${musl}/lib -L${musl}/lib")
  '';

  nativeBuildInputs = lib.optional (hostPlatform != buildPlatform) buildPackages.stdenv.cc;

  buildInputs = lib.optionals (enableStatic && !useMusl) [ stdenv.cc.libc stdenv.cc.libc.static ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Tiny versions of common UNIX utilities in a single small executable";
    homepage = https://busybox.net/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ viric ];
    platforms = platforms.linux;
  };
}
