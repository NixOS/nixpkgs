{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchurl,
  fetchpatch,
  substituteAll,
  cmake,
  makeWrapper,
  pkg-config,
  curl,
  ffmpeg,
  glib,
  libjpeg,
  libselinux,
  libsepol,
  mp4v2,
  libmysqlclient,
  mariadb,
  pcre,
  perl,
  perlPackages,
  polkit,
  util-linuxMinimal,
  x264,
  zlib,
  coreutils,
  procps,
  psmisc,
  nixosTests,
}:

# NOTES:
#
# 1. ZM_CONFIG_DIR is set to $out/etc/zoneminder as the .conf file distributed
# by upstream contains defaults and is not supposed to be edited so it is fine
# to keep it read-only.
#
# 2. ZM_CONFIG_SUBDIR is where we place our configuration from the NixOS module
# but as the installer will try to put files there, we patch Config.pm after the
# install.
#
# 3. ZoneMinder is run with -T passed to the perl interpreter which makes perl
# ignore PERL5LIB. We therefore have to do the substitution into -I parameters
# ourselves which results in ugly wrappers.
#
# 4. The makefile for the perl modules needs patching to put things into the
# right place. That also means we have to not run "make install" for them.
#
# 5. In principal the various ZM_xx variables should be overridable from the
# config file but some of them are baked into the perl scripts, so we *have* to
# set them here instead of in the configuration in the NixOS module.
#
# 6. I am no PolicyKit expert but the .policy file looks fishy:
#   a. The user needs to be known at build-time so we should probably throw
#   upstream's policy file away and generate it from the NixOS module
#   b. I *think* we may have to substitute the store paths with
#   /run/current-system/sw/bin paths for it to work.
#
# 7. we manually fix up the perl paths in the scripts as fixupPhase will only
# handle pkexec and not perl if both are present.
#
# 8. There are several perl modules needed at runtime which are not checked when
# building so if a new version stops working, check if there is a missing
# dependency by running the failing component manually.
#
# 9. Parts of the web UI has a hardcoded /zm path so we create a symlink to work
# around it.

let
  addons = [
    {
      path = "scripts/ZoneMinder/lib/ZoneMinder/Control/Xiaomi.pm";
      src = fetchurl {
        url = "https://gist.githubusercontent.com/joshstrange/73a2f24dfaf5cd5b470024096ce2680f/raw/e964270c5cdbf95e5b7f214f7f0fc6113791530e/Xiaomi.pm";
        sha256 = "04n1ap8fx66xfl9q9rypj48pzbgzikq0gisfsfm8wdsmflarz43v";
      };
    }
  ];

  user = "zoneminder";
  dirName = "zoneminder";
  perlBin = "${perl}/bin/perl";

in
stdenv.mkDerivation rec {
  pname = "zoneminder";
  version = "1.36.35";

  src = fetchFromGitHub {
    owner = "ZoneMinder";
    repo = "zoneminder";
    rev = version;
    hash = "sha256-0mpT3qjF8zlcsd6OlNIvrabDsz+oJPPy9Vn2TQSuHAI=";
    fetchSubmodules = true;
  };

  patches = [
    ./default-to-http-1dot1.patch
    ./0001-Don-t-use-file-timestamp-in-cache-filename.patch
  ];

  postPatch = ''
    rm -rf web/api/lib/Cake/Test

    ${lib.concatStringsSep "\n" (
      map (e: ''
        cp ${e.src} ${e.path}
      '') addons
    )}

    for d in scripts/ZoneMinder onvif/{modules,proxy} ; do
      substituteInPlace $d/CMakeLists.txt \
        --replace 'DESTDIR="''${CMAKE_CURRENT_BINARY_DIR}/output"' "PREFIX=$out INSTALLDIRS=site"
      sed -i '/^install/d' $d/CMakeLists.txt
    done

    substituteInPlace misc/CMakeLists.txt \
      --replace '"''${PC_POLKIT_PREFIX}/''${CMAKE_INSTALL_DATAROOTDIR}' "\"$out/share"

    for f in misc/*.policy.in \
             scripts/*.pl* \
             scripts/ZoneMinder/lib/ZoneMinder/Memory.pm.in ; do
      substituteInPlace $f \
        --replace '/usr/bin/perl' '${perlBin}' \
        --replace '/bin:/usr/bin' "$out/bin:${
          lib.makeBinPath [
            coreutils
            procps
            psmisc
          ]
        }"
    done

    substituteInPlace scripts/zmdbbackup.in \
      --replace /usr/bin/mysqldump ${mariadb.client}/bin/mysqldump

    substituteInPlace scripts/zmupdate.pl.in \
      --replace "'mysql'" "'${mariadb.client}/bin/mysql'" \
      --replace "'mysqldump'" "'${mariadb.client}/bin/mysqldump'"

    for f in scripts/ZoneMinder/lib/ZoneMinder/Config.pm.in \
             scripts/zmupdate.pl.in \
             src/zm_config_data.h.in \
             web/api/app/Config/bootstrap.php.in \
             web/includes/config.php.in ; do
      substituteInPlace $f --replace @ZM_CONFIG_SUBDIR@ /etc/zoneminder
    done

    for f in includes/Event.php views/image.php ; do
      substituteInPlace web/$f \
        --replace "'ffmpeg " "'${ffmpeg}/bin/ffmpeg "
    done

    for f in scripts/ZoneMinder/lib/ZoneMinder/Event.pm \
             scripts/ZoneMinder/lib/ZoneMinder/Storage.pm ; do
      substituteInPlace $f \
        --replace '/bin/rm' "${coreutils}/bin/rm"
    done

    substituteInPlace web/includes/functions.php \
      --replace "'date " "'${coreutils}/bin/date " \
      --subst-var-by srcHash "`basename $out`"
  '';

  buildInputs =
    [
      curl
      ffmpeg
      glib
      libjpeg
      libselinux
      libsepol
      mp4v2
      libmysqlclient
      mariadb
      pcre
      perl
      polkit
      x264
      zlib
      util-linuxMinimal # for libmount
    ]
    ++ (with perlPackages; [
      # build-time dependencies
      DateManip
      DBI
      DBDmysql
      LWP
      SysMmap
      # run-time dependencies not checked at build-time
      ClassStdFast
      DataDump
      DeviceSerialPort
      JSONMaybeXS
      LWPProtocolHttps
      NumberBytesHuman
      SysCPU
      SysMemInfo
      TimeDate
      CryptEksblowfish
      DataEntropy # zmupdate.pl
    ]);

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
  ];

  cmakeFlags = [
    "-DWITH_SYSTEMD=ON"
    "-DZM_LOGDIR=/var/log/${dirName}"
    "-DZM_RUNDIR=/run/${dirName}"
    "-DZM_SOCKDIR=/run/${dirName}"
    "-DZM_TMPDIR=/tmp/${dirName}"
    "-DZM_CONFIG_DIR=${placeholder "out"}/etc/zoneminder"
    "-DZM_WEB_USER=${user}"
    "-DZM_WEB_GROUP=${user}"
  ];

  passthru = {
    inherit dirName;
    tests = nixosTests.zoneminder;
  };

  postInstall = ''
    PERL5LIB="$PERL5LIB''${PERL5LIB:+:}$out/${perl.libPrefix}"

    perlFlags="-wT"
    for i in $(IFS=$'\n'; echo $PERL5LIB | tr ':' "\n" | sort -u); do
      perlFlags="$perlFlags -I$i"
    done

    mkdir -p $out/libexec
    for f in $out/bin/*.pl ; do
      mv $f $out/libexec/
      makeWrapper ${perlBin} $f \
        --prefix PATH : $out/bin \
        --add-flags "$perlFlags $out/libexec/$(basename $f)"
    done

    ln -s $out/share/zoneminder/www $out/share/zoneminder/www/zm
  '';

  meta = with lib; {
    description = "Video surveillance software system";
    homepage = "https://zoneminder.com";
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
