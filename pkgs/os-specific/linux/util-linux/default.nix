{ lib, stdenv, fetchurl, fetchpatch, pkg-config, zlib, shadow
, capabilitiesSupport ? stdenv.isLinux
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
, writeSupport ? stdenv.isLinux
, shadowSupport ? stdenv.isLinux
, memstreamHook
}:

stdenv.mkDerivation rec {
  pname = "util-linux" + lib.optionalString (!nlsSupport && !ncursesSupport && !systemdSupport) "-minimal";
  version = "2.39";

  src = fetchurl {
    url = "mirror://kernel/linux/utils/util-linux/v${lib.versions.majorMinor version}/util-linux-${version}.tar.xz";
    hash = "sha256-MrMKM2zakDGC7WH+s+m5CLdipeZv4U5D77iNNxYgdcs=";
  };

  patches = [
    ./rtcwake-search-PATH-for-shutdown.patch

    # FIXME: backport mount fixes for older kernels, remove in next release
    (fetchpatch {
      url = "https://github.com/util-linux/util-linux/commit/f94a7760ed7ce81389a6059f020238981627a70d.diff";
      hash = "sha256-UorqDeECK8pBePkmpo2x90p/jP3rCMshyPCyijSX1wo=";
    })
    (fetchpatch {
      url = "https://github.com/util-linux/util-linux/commit/1bd85b64632280d6bf0e86b4ff29da8b19321c5f.diff";
      hash = "sha256-dgu4de5ul/si7Vzwe8lr9NvsdI1CWfDQKuqvARaY6sE=";
    })

    # FIXME: backport bcache detection fixes, remove in next release
    (fetchpatch {
      url = "https://github.com/util-linux/util-linux/commit/158639a2a4c6e646fd4fa0acb5f4743e65daa415.diff";
      hash = "sha256-9F1OQFxKuI383u6MVy/UM15B6B+tkZFRwuDbgoZrWME=";
    })
    (fetchpatch {
      url = "https://github.com/util-linux/util-linux/commit/00a19fb8cdfeeae30a6688ac6b490e80371b2257.diff";
      hash = "sha256-w1S6IKSoL6JhVew9t6EemNRc/nrJQ5oMqFekcx0kno8=";
    })
  ];

  outputs = [ "bin" "dev" "out" "lib" "man" ];
  separateDebugInfo = true;

  postPatch = ''
    patchShebangs tests/run.sh

    substituteInPlace sys-utils/eject.c \
      --replace "/bin/umount" "$bin/bin/umount"
  '' + lib.optionalString shadowSupport ''
    substituteInPlace include/pathnames.h \
      --replace "/bin/login" "${shadow}/bin/login"
  '';

  # !!! It would be better to obtain the path to the mount helpers
  # (/sbin/mount.*) through an environment variable, but that's
  # somewhat risky because we have to consider that mount can setuid
  # root...
  configureFlags = [
    "--localstatedir=/var"
    "--disable-use-tty-group"
    "--enable-fs-paths-default=/run/wrappers/bin:/run/current-system/sw/bin:/sbin"
    "--disable-makeinstall-setuid" "--disable-makeinstall-chown"
    "--disable-su" # provided by shadow
    (lib.enableFeature writeSupport "write")
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
    ++ lib.optionals systemdSupport [ systemd ]
    ++ lib.optionals (stdenv.system == "x86_64-darwin") [ memstreamHook ];

  doCheck = false; # "For development purpose only. Don't execute on production system!"

  enableParallelBuilding = true;

  postInstall = ''
    installShellCompletion --bash bash-completion/*
  '';

  meta = with lib; {
    homepage = "https://www.kernel.org/pub/linux/utils/util-linux/";
    description = "A set of system utilities for Linux";
    changelog = "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v${lib.versions.majorMinor version}/v${version}-ReleaseNotes";
    # https://git.kernel.org/pub/scm/utils/util-linux/util-linux.git/tree/README.licensing
    license = with licenses; [ gpl2Only gpl2Plus gpl3Plus lgpl21Plus bsd3 bsdOriginalUC publicDomain ];
    platforms = platforms.unix;
    priority = 6; # lower priority than coreutils ("kill") and shadow ("login" etc.) packages
  };
}
