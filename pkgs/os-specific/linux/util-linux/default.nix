{ lib, stdenv, fetchurl, pkg-config, zlib, shadow
<<<<<<< HEAD
, capabilitiesSupport ? stdenv.isLinux
=======
, capabilitiesSupport ? true
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, libcap_ng
, libxcrypt
, ncursesSupport ? true
, ncurses
, pamSupport ? true
, pam
, systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd
, systemd
, nlsSupport ? true
, translateManpages ? true
, po4a
, installShellFiles
<<<<<<< HEAD
, writeSupport ? stdenv.isLinux
, shadowSupport ? stdenv.isLinux
, memstreamHook
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "util-linux" + lib.optionalString (!nlsSupport && !ncursesSupport && !systemdSupport) "-minimal";
<<<<<<< HEAD
  version = "2.39.1";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/util-linux/v${lib.versions.majorMinor version}/util-linux-${version}.tar.xz";
    hash = "sha256-iQro/4ECR70Z4nTfdug3HSAs2gGtJ3aBsOqI7qoAKGs=";
=======
  version = "2.38.1";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/util-linux/v${lib.versions.majorMinor version}/util-linux-${version}.tar.xz";
    hash = "sha256-YEkqGbRObPmj3f9oMlszO4tStsWc4+vWoOyqTFEX6E8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    ./rtcwake-search-PATH-for-shutdown.patch
  ];

<<<<<<< HEAD
  # We separate some of the utilities into their own outputs. This
  # allows putting together smaller systems depending on only part of
  # the greater util-linux toolset.
  # Compatibility is maintained by symlinking the binaries from the
  # smaller outputs in the bin output.
  outputs = [ "bin" "dev" "out" "lib" "man" ] ++ lib.optionals stdenv.isLinux [ "mount" ] ++ [ "login" ] ++ lib.optionals stdenv.isLinux [ "swap" ];
=======
  outputs = [ "bin" "dev" "out" "lib" "man" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  separateDebugInfo = true;

  postPatch = ''
    patchShebangs tests/run.sh

<<<<<<< HEAD
    substituteInPlace sys-utils/eject.c \
      --replace "/bin/umount" "$bin/bin/umount"
  '' + lib.optionalString shadowSupport ''
    substituteInPlace include/pathnames.h \
      --replace "/bin/login" "${shadow}/bin/login"
=======
    substituteInPlace include/pathnames.h \
      --replace "/bin/login" "${shadow}/bin/login"
    substituteInPlace sys-utils/eject.c \
      --replace "/bin/umount" "$bin/bin/umount"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  # !!! It would be better to obtain the path to the mount helpers
  # (/sbin/mount.*) through an environment variable, but that's
  # somewhat risky because we have to consider that mount can setuid
  # root...
  configureFlags = [
    "--localstatedir=/var"
<<<<<<< HEAD
=======
    "--enable-write"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "--disable-use-tty-group"
    "--enable-fs-paths-default=/run/wrappers/bin:/run/current-system/sw/bin:/sbin"
    "--disable-makeinstall-setuid" "--disable-makeinstall-chown"
    "--disable-su" # provided by shadow
<<<<<<< HEAD
    (lib.enableFeature writeSupport "write")
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    (lib.enableFeature nlsSupport "nls")
    (lib.withFeature ncursesSupport "ncursesw")
    (lib.withFeature systemdSupport "systemd")
    (lib.withFeatureAs systemdSupport
       "systemdsystemunitdir" "${placeholder "bin"}/lib/systemd/system/")
    (lib.enableFeature translateManpages "poman")
    "SYSCONFSTATICDIR=${placeholder "lib"}/lib"
  ] ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform)
       "scanf_cv_type_modifier=ms"
  ;

  makeFlags = [
    "usrbin_execdir=${placeholder "bin"}/bin"
    "usrlib_execdir=${placeholder "lib"}/lib"
    "usrsbin_execdir=${placeholder "bin"}/sbin"
  ];

  nativeBuildInputs = [ pkg-config installShellFiles ]
    ++ lib.optionals translateManpages [ po4a ];

  buildInputs = [ zlib libxcrypt ]
    ++ lib.optionals pamSupport [ pam ]
    ++ lib.optionals capabilitiesSupport [ libcap_ng ]
    ++ lib.optionals ncursesSupport [ ncurses ]
<<<<<<< HEAD
    ++ lib.optionals systemdSupport [ systemd ]
    ++ lib.optionals (stdenv.system == "x86_64-darwin") [ memstreamHook ];
=======
    ++ lib.optionals systemdSupport [ systemd ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false; # "For development purpose only. Don't execute on production system!"

  enableParallelBuilding = true;

<<<<<<< HEAD
  postInstall = lib.optionalString stdenv.isLinux ''
    moveToOutput bin/mount "$mount"
    moveToOutput bin/umount "$mount"
    ln -svf "$mount/bin/"* $bin/bin/
    '' + ''

    moveToOutput sbin/nologin "$login"
    moveToOutput sbin/sulogin "$login"
    prefix=$login _moveSbin
    ln -svf "$login/bin/"* $bin/bin/
    '' + lib.optionalString stdenv.isLinux ''

    moveToOutput sbin/swapon "$swap"
    moveToOutput sbin/swapoff "$swap"
    prefix=$swap _moveSbin
    ln -svf "$swap/bin/"* $bin/bin/
    '' + ''

=======
  postInstall = ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    installShellCompletion --bash bash-completion/*
  '';

  meta = with lib; {
    homepage = "https://www.kernel.org/pub/linux/utils/util-linux/";
    description = "A set of system utilities for Linux";
    changelog = "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v${lib.versions.majorMinor version}/v${version}-ReleaseNotes";
    # https://git.kernel.org/pub/scm/utils/util-linux/util-linux.git/tree/README.licensing
    license = with licenses; [ gpl2Only gpl2Plus gpl3Plus lgpl21Plus bsd3 bsdOriginalUC publicDomain ];
<<<<<<< HEAD
    platforms = platforms.unix;
    pkgConfigModules = [
      "blkid"
      "fdisk"
      "mount"
      "smartcols"
      "uuid"
    ];
=======
    platforms = platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    priority = 6; # lower priority than coreutils ("kill") and shadow ("login" etc.) packages
  };
}
