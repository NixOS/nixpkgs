{ stdenv, lib, fetchurl, fetchpatch, makeWrapper, autoreconfHook
, pkg-config, which
, flex, bison
, linuxHeaders ? stdenv.cc.libc.linuxHeaders
, gawk
, withPerl ? stdenv.hostPlatform == stdenv.buildPlatform && lib.meta.availableOn stdenv.hostPlatform perl, perl
, withPython ? stdenv.hostPlatform == stdenv.buildPlatform && lib.meta.availableOn stdenv.hostPlatform python, python
, swig
, ncurses
, pam
, libnotify
, buildPackages
, coreutils
, gnugrep
, gnused
, kmod
, writeShellScript
, closureInfo
, runCommand
}:

let
  apparmor-version = "3.0.1";

  apparmor-meta = component: with lib; {
    homepage = "https://apparmor.net/";
    description = "A mandatory access control system - ${component}";
    license = licenses.gpl2;
    maintainers = with maintainers; [ joachifm julm phreedom thoughtpolice ];
    platforms = platforms.linux;
  };

  apparmor-sources = fetchurl {
    url = "https://launchpad.net/apparmor/${lib.versions.majorMinor apparmor-version}/${apparmor-version}/+download/apparmor-${apparmor-version}.tar.gz";
    sha256 = "096zbg3v7b51x7f1ly61mzd3iy9alad6sd4lam98j2d6v5ragbcg";
  };

  aa-teardown = writeShellScript "aa-teardown" ''
    PATH="${lib.makeBinPath [coreutils gnused gnugrep]}:$PATH"
    . ${apparmor-parser}/lib/apparmor/rc.apparmor.functions
    remove_profiles
  '';

  prePatchCommon = ''
    chmod a+x ./common/list_capabilities.sh ./common/list_af_names.sh
    patchShebangs ./common/list_capabilities.sh ./common/list_af_names.sh
    substituteInPlace ./common/Make.rules --replace "/usr/bin/pod2man" "${buildPackages.perl}/bin/pod2man"
    substituteInPlace ./common/Make.rules --replace "/usr/bin/pod2html" "${buildPackages.perl}/bin/pod2html"
    substituteInPlace ./common/Make.rules --replace "/usr/include/linux/capability.h" "${linuxHeaders}/include/linux/capability.h"
    substituteInPlace ./common/Make.rules --replace "/usr/share/man" "share/man"
  '';

  patches = lib.optionals stdenv.hostPlatform.isMusl [
    (fetchpatch {
      url = "https://git.alpinelinux.org/aports/plain/testing/apparmor/0003-Added-missing-typedef-definitions-on-parser.patch?id=74b8427cc21f04e32030d047ae92caa618105b53";
      name = "0003-Added-missing-typedef-definitions-on-parser.patch";
      sha256 = "0yyaqz8jlmn1bm37arggprqz0njb4lhjni2d9c8qfqj0kll0bam0";
    })
    ];

  # Set to `true` after the next FIXME gets fixed or this gets some
  # common derivation infra. Too much copy-paste to fix one by one.
  doCheck = false;

  # FIXME: convert these to a single multiple-outputs package?

  libapparmor = stdenv.mkDerivation {
    name = "libapparmor-${apparmor-version}";
    src = apparmor-sources;

    nativeBuildInputs = [
      autoreconfHook
      bison
      flex
      pkg-config
      swig
      ncurses
      which
      perl
    ];

    buildInputs = []
      ++ lib.optional withPerl perl
      ++ lib.optional withPython python;

    # required to build apparmor-parser
    dontDisableStatic = true;

    prePatch = prePatchCommon + ''
      substituteInPlace ./libraries/libapparmor/swig/perl/Makefile.am --replace install_vendor install_site
      substituteInPlace ./libraries/libapparmor/swig/perl/Makefile.in --replace install_vendor install_site
      substituteInPlace ./libraries/libapparmor/src/Makefile.am --replace "/usr/include/netinet/in.h" "${lib.getDev stdenv.cc.libc}/include/netinet/in.h"
      substituteInPlace ./libraries/libapparmor/src/Makefile.in --replace "/usr/include/netinet/in.h" "${lib.getDev stdenv.cc.libc}/include/netinet/in.h"
    '';
    inherit patches;

    postPatch = "cd ./libraries/libapparmor";
    # https://gitlab.com/apparmor/apparmor/issues/1
    configureFlags = [
      (lib.withFeature withPerl "perl")
      (lib.withFeature withPython "python")
    ];

    outputs = [ "out" ] ++ lib.optional withPython "python";

    postInstall = lib.optionalString withPython ''
      mkdir -p $python/lib
      mv $out/lib/python* $python/lib/
    '';

    inherit doCheck;

    meta = apparmor-meta "library";
  };

  apparmor-utils = stdenv.mkDerivation {
    name = "apparmor-utils-${apparmor-version}";
    src = apparmor-sources;

    nativeBuildInputs = [ makeWrapper which ];

    buildInputs = [
      perl
      python
      libapparmor
      libapparmor.python
    ];

    prePatch = prePatchCommon +
      # Do not build vim file
      lib.optionalString stdenv.hostPlatform.isMusl ''
        sed -i ./utils/Makefile -e "/\<vim\>/d"
      '' + ''
      substituteInPlace ./utils/apparmor/easyprof.py --replace "/sbin/apparmor_parser" "${apparmor-parser}/bin/apparmor_parser"
      substituteInPlace ./utils/apparmor/aa.py --replace "/sbin/apparmor_parser" "${apparmor-parser}/bin/apparmor_parser"
      substituteInPlace ./utils/logprof.conf --replace "/sbin/apparmor_parser" "${apparmor-parser}/bin/apparmor_parser"
    '';
    inherit patches;
    postPatch = "cd ./utils";
    makeFlags = [ "LANGS=" ];
    installFlags = [ "DESTDIR=$(out)" "BINDIR=$(out)/bin" "VIM_INSTALL_PATH=$(out)/share" "PYPREFIX=" ];

    postInstall = ''
      sed -i $out/bin/aa-unconfined -e "/my_env\['PATH'\]/d"
      for prog in aa-audit aa-autodep aa-cleanprof aa-complain aa-disable aa-enforce aa-genprof aa-logprof aa-mergeprof aa-unconfined ; do
        wrapProgram $out/bin/$prog --prefix PYTHONPATH : "$out/lib/${python.libPrefix}/site-packages:$PYTHONPATH"
      done

      substituteInPlace $out/bin/aa-notify \
        --replace /usr/bin/notify-send ${libnotify}/bin/notify-send \
        --replace /usr/bin/perl "${perl}/bin/perl -I ${libapparmor}/${perl.libPrefix}"

      substituteInPlace $out/bin/aa-remove-unknown \
       --replace "/lib/apparmor/rc.apparmor.functions" "${apparmor-parser}/lib/apparmor/rc.apparmor.functions"
      wrapProgram $out/bin/aa-remove-unknown \
       --prefix PATH : ${lib.makeBinPath [gawk]}

      ln -s ${aa-teardown} $out/bin/aa-teardown
    '';

    inherit doCheck;

    meta = apparmor-meta "user-land utilities" // {
      broken = !(withPython && withPerl);
    };
  };

  apparmor-bin-utils = stdenv.mkDerivation {
    name = "apparmor-bin-utils-${apparmor-version}";
    src = apparmor-sources;

    nativeBuildInputs = [
      pkg-config
      libapparmor
      gawk
      which
    ];

    buildInputs = [
      libapparmor
    ];

    prePatch = prePatchCommon;
    postPatch = "cd ./binutils";
    makeFlags = [ "LANGS=" "USE_SYSTEM=1" ];
    installFlags = [ "DESTDIR=$(out)" "BINDIR=$(out)/bin" "SBINDIR=$(out)/bin" ];

    inherit doCheck;

    meta = apparmor-meta "binary user-land utilities";
  };

  apparmor-parser = stdenv.mkDerivation {
    name = "apparmor-parser-${apparmor-version}";
    src = apparmor-sources;

    nativeBuildInputs = [ bison flex which ];

    buildInputs = [ libapparmor ];

    prePatch = prePatchCommon + ''
      substituteInPlace ./parser/Makefile --replace "/usr/bin/bison" "${bison}/bin/bison"
      substituteInPlace ./parser/Makefile --replace "/usr/bin/flex" "${flex}/bin/flex"
      substituteInPlace ./parser/Makefile --replace "/usr/include/linux/capability.h" "${linuxHeaders}/include/linux/capability.h"
      ## techdoc.pdf still doesn't build ...
      substituteInPlace ./parser/Makefile --replace "manpages htmlmanpages pdf" "manpages htmlmanpages"
      substituteInPlace parser/rc.apparmor.functions \
       --replace "/sbin/apparmor_parser" "$out/bin/apparmor_parser"
      sed -i parser/rc.apparmor.functions -e '2i . ${./fix-rc.apparmor.functions.sh}'
    '';
    inherit patches;
    postPatch = "cd ./parser";
    makeFlags = [
      "LANGS=" "USE_SYSTEM=1" "INCLUDEDIR=${libapparmor}/include"
      "AR=${stdenv.cc.bintools.targetPrefix}ar"
    ];
    installFlags = [ "DESTDIR=$(out)" "DISTRO=unknown" ];

    inherit doCheck;

    meta = apparmor-meta "rule parser";
  };

  apparmor-pam = stdenv.mkDerivation {
    name = "apparmor-pam-${apparmor-version}";
    src = apparmor-sources;

    nativeBuildInputs = [ pkg-config which ];

    buildInputs = [ libapparmor pam ];

    postPatch = "cd ./changehat/pam_apparmor";
    makeFlags = [ "USE_SYSTEM=1" ];
    installFlags = [ "DESTDIR=$(out)" ];

    inherit doCheck;

    meta = apparmor-meta "PAM service";
  };

  apparmor-profiles = stdenv.mkDerivation {
    name = "apparmor-profiles-${apparmor-version}";
    src = apparmor-sources;

    nativeBuildInputs = [ which ];

    postPatch = "cd ./profiles";
    installFlags = [ "DESTDIR=$(out)" "EXTRAS_DEST=$(out)/share/apparmor/extra-profiles" ];

    inherit doCheck;

    meta = apparmor-meta "profiles";
  };

  apparmor-kernel-patches = stdenv.mkDerivation {
    name = "apparmor-kernel-patches-${apparmor-version}";
    src = apparmor-sources;

    phases = "unpackPhase installPhase";

    installPhase = ''
      mkdir "$out"
      cp -R ./kernel-patches/* "$out"
    '';

    inherit doCheck;

    meta = apparmor-meta "kernel patches";
  };

  # Generate generic AppArmor rules in a file,
  # from the closure of given rootPaths.
  # To be included in an AppArmor profile like so:
  # include "$(apparmorRulesFromClosure {} [pkgs.hello]}"
  apparmorRulesFromClosure =
    { # The store path of the derivation is given in $path
      additionalRules ? []
      # TODO: factorize here some other common paths
      # that may emerge from use cases.
    , baseRules ? [
        "r $path"
        "r $path/etc/**"
        "r $path/share/**"
        # Note that not all libraries are prefixed with "lib",
        # eg. glibc-2.30/lib/ld-2.30.so
        "mr $path/lib/**.so*"
        # eg. glibc-2.30/lib/gconv/gconv-modules
        "r $path/lib/**"
      ]
    , name ? ""
    }: rootPaths: runCommand
      ( "apparmor-closure-rules"
      + lib.optionalString (name != "") "-${name}" ) {} ''
    touch $out
    while read -r path
    do printf >>$out "%s,\n" ${lib.concatMapStringsSep " " (x: "\"${x}\"") (baseRules ++ additionalRules)}
    done <${closureInfo {inherit rootPaths;}}/store-paths
  '';
in
{
  inherit
    libapparmor
    apparmor-utils
    apparmor-bin-utils
    apparmor-parser
    apparmor-pam
    apparmor-profiles
    apparmor-kernel-patches
    apparmorRulesFromClosure;
}
