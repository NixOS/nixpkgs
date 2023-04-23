{ stdenv, appleDerivation, lib
, libutil, Librpcsvc, apple_sdk, pam, CF, openbsm }:

appleDerivation {
  # xcbuild fails with:
  # /nix/store/fc0rz62dh8vr648qi7hnqyik6zi5sqx8-xcbuild-wrapper/nix-support/setup-hook: line 1:  9083 Segmentation fault: 11  xcodebuild OTHER_CFLAGS="$NIX_CFLAGS_COMPILE" OTHER_CPLUSPLUSFLAGS="$NIX_CFLAGS_COMPILE" OTHER_LDFLAGS="$NIX_LDFLAGS" build
  # see issue facebook/xcbuild#188
  # buildInputs = [ xcbuild ];

  buildInputs = [ libutil Librpcsvc apple_sdk.frameworks.OpenDirectory pam CF
                  apple_sdk.frameworks.IOKit openbsm ];
  # env.NIX_CFLAGS_COMPILE = lib.optionalString hostPlatform.isi686 "-D__i386__"
  #                    + lib.optionalString hostPlatform.isx86_64 "-D__x86_64__"
  #                    + lib.optionalString hostPlatform.isAarch32 "-D__arm__";
  env.NIX_CFLAGS_COMPILE = toString ([ "-DDAEMON_UID=1"
                         "-DDAEMON_GID=1"
                         "-DDEFAULT_AT_QUEUE='a'"
                         "-DDEFAULT_BATCH_QUEUE='b'"
                         "-DPERM_PATH=\"/usr/lib/cron/\""
                         "-DOPEN_DIRECTORY"
                         "-DNO_DIRECT_RPC"
                         "-DAPPLE_GETCONF_UNDERSCORE"
                         "-DAPPLE_GETCONF_SPEC"
                         "-DUSE_PAM"
                         "-DUSE_BSM_AUDIT"
                         "-D_PW_NAME_LEN=MAXLOGNAME"
                         "-D_PW_YPTOKEN=\"__YP!\""
                         "-DAHZV1=64 "
                         "-DAU_SESSION_FLAG_HAS_TTY=0x4000"
                         "-DAU_SESSION_FLAG_HAS_AUTHENTICATED=0x4000"
                       ] ++ lib.optional (!stdenv.isLinux) " -D__FreeBSD__ ");

  patchPhase = ''
    substituteInPlace login.tproj/login.c \
      --replace bsm/audit_session.h bsm/audit.h
    substituteInPlace login.tproj/login_audit.c \
      --replace bsm/audit_session.h bsm/audit.h
  '' + lib.optionalString stdenv.isAarch64 ''
    substituteInPlace sysctl.tproj/sysctl.c \
      --replace "GPROF_STATE" "0"
    substituteInPlace login.tproj/login.c \
      --replace "defined(__arm__)" "defined(__arm__) || defined(__arm64__)"
  '';

  buildPhase = ''
    for dir in *.tproj; do
      name=$(basename $dir)
      name=''${name%.tproj}

      CFLAGS=""
      case $name in
           arch) CFLAGS="-framework CoreFoundation";;
           atrun) CFLAGS="-Iat.tproj";;
           chkpasswd)
             CFLAGS="-framework OpenDirectory -framework CoreFoundation -lpam";;
           getconf)
               for f in getconf.tproj/*.gperf; do
                   cfile=''${f%.gperf}.c
                   LC_ALL=C awk -f getconf.tproj/fake-gperf.awk $f > $cfile
               done
           ;;
           iostat) CFLAGS="-framework IOKit -framework CoreFoundation";;
           login) CFLAGS="-lbsm -lpam";;
           nvram) CFLAGS="-framework CoreFoundation -framework IOKit";;
           sadc) CFLAGS="-framework IOKit -framework CoreFoundation";;
           sar) CFLAGS="-Isadc.tproj";;
      esac

      echo "Building $name"

      case $name in

           # These are all broken currently.
           arch) continue;;
           chpass) continue;;
           dirhelper) continue;;
           dynamic_pager) continue;;
           fs_usage) continue;;
           latency) continue;;
           pagesize) continue;;
           passwd) continue;;
           reboot) continue;;
           sc_usage) continue;;
           shutdown) continue;;
           trace) continue;;

           *) cc $dir/*.c -I''${dir} $CFLAGS -o $name ;;
      esac
    done
  '';

  installPhase = ''
    for dir in *.tproj; do
      name=$(basename $dir)
      name=''${name%.tproj}
      [ -x $name ] && install -D $name $out/bin/$name
      for n in 1 2 3 4 5 6 7 8 9; do
        for f in $dir/*.$n; do
          install -D $f $out/share/man/man$n/$(basename $f)
        done
      done
    done
  '';

  meta = {
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ shlevy matthewbauer ];
  };
}
