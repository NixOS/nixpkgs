{ stdenv, fetchurl, fetchpatch, makeWrapper, autoreconfHook
, pkgconfig, which
, flex, bison
, linuxHeaders ? stdenv.cc.libc.linuxHeaders
, python
, gawk
, perl
, swig
, ncurses
, pam
}:

let
  apparmor-series = "2.12";
  apparmor-patchver = "0";
  apparmor-version = apparmor-series + "." + apparmor-patchver;

  apparmor-meta = component: with stdenv.lib; {
    homepage = http://apparmor.net/;
    description = "A mandatory access control system - ${component}";
    license = licenses.gpl2;
    maintainers = with maintainers; [ phreedom thoughtpolice joachifm ];
    platforms = platforms.linux;
  };

  apparmor-sources = fetchurl {
    url = "https://launchpad.net/apparmor/${apparmor-series}/${apparmor-version}/+download/apparmor-${apparmor-series}.tar.gz";
    sha256 = "0mm0mcp0w18si9wl15drndysm7v27az2942p1xjd197shg80qawa";
  };

  prePatchCommon = ''
    substituteInPlace ./common/Make.rules --replace "/usr/bin/pod2man" "${perl}/bin/pod2man"
    substituteInPlace ./common/Make.rules --replace "/usr/bin/pod2html" "${perl}/bin/pod2html"
    substituteInPlace ./common/Make.rules --replace "/usr/include/linux/capability.h" "${linuxHeaders}/include/linux/capability.h"
    substituteInPlace ./common/Make.rules --replace "/usr/share/man" "share/man"
  '';

  # use 'if c then x else null' to avoid rebuilding
  # patches = stdenv.lib.optionals stdenv.hostPlatform.isMusl [
  patches = if stdenv.hostPlatform.isMusl then [
    (fetchpatch {
      url = "https://git.alpinelinux.org/cgit/aports/plain/testing/apparmor/0002-Provide-missing-secure_getenv-and-scandirat-function.patch?id=74b8427cc21f04e32030d047ae92caa618105b53";
      name = "0002-Provide-missing-secure_getenv-and-scandirat-function.patch";
      sha256 = "0pj1bzifghxwxlc39j8hyy17dkjr9fk64kkj94ayymyprz4i4nac";
    })
    (fetchpatch {
      url = "https://git.alpinelinux.org/cgit/aports/plain/testing/apparmor/0003-Added-missing-typedef-definitions-on-parser.patch?id=74b8427cc21f04e32030d047ae92caa618105b53";
      name = "0003-Added-missing-typedef-definitions-on-parser.patch";
      sha256 = "0yyaqz8jlmn1bm37arggprqz0njb4lhjni2d9c8qfqj0kll0bam0";
    })
    (fetchpatch {
      url = "https://git.alpinelinux.org/cgit/aports/plain/testing/apparmor/0007-Do-not-build-install-vim-file-with-utils-package.patch?id=74b8427cc21f04e32030d047ae92caa618105b53";
      name = "0007-Do-not-build-install-vim-file-with-utils-package.patch";
      sha256 = "1m4dx901biqgnr4w4wz8a2z9r9dxyw7wv6m6mqglqwf2lxinqmp4";
    })
    # (alpine patches {1,4,5,6,8} are needed for apparmor 2.11, but not 2.12)
  ] else null;

  # FIXME: convert these to a single multiple-outputs package?

  libapparmor = stdenv.mkDerivation {
    name = "libapparmor-${apparmor-version}";
    src = apparmor-sources;

    nativeBuildInputs = [
      autoreconfHook
      bison
      flex
      pkgconfig
      swig
      ncurses
      which
    ];

    buildInputs = [
      perl
      python
    ];

    # required to build apparmor-parser
    dontDisableStatic = true;

    prePatch = prePatchCommon + ''
      substituteInPlace ./libraries/libapparmor/src/Makefile.am --replace "/usr/include/netinet/in.h" "${stdenv.cc.libc.dev}/include/netinet/in.h"
      substituteInPlace ./libraries/libapparmor/src/Makefile.in --replace "/usr/include/netinet/in.h" "${stdenv.cc.libc.dev}/include/netinet/in.h"
    '';
    inherit patches;

    postPatch = "cd ./libraries/libapparmor";
    configureFlags = "--with-python --with-perl";

    outputs = [ "out" "python" ];

    postInstall = ''
      mkdir -p $python/lib
      mv $out/lib/python* $python/lib/
    '';

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

    prePatch = prePatchCommon;
    inherit patches;
    postPatch = "cd ./utils";
    makeFlags = ''LANGS='';
    installFlags = ''DESTDIR=$(out) BINDIR=$(out)/bin VIM_INSTALL_PATH=$(out)/share PYPREFIX='';

    postInstall = ''
      for prog in aa-audit aa-autodep aa-cleanprof aa-complain aa-disable aa-enforce aa-genprof aa-logprof aa-mergeprof aa-status aa-unconfined ; do
        wrapProgram $out/bin/$prog --prefix PYTHONPATH : "$out/lib/${python.libPrefix}/site-packages:$PYTHONPATH"
      done

      for prog in aa-notify ; do
        wrapProgram $out/bin/$prog --prefix PERL5LIB : "${libapparmor}/lib/perl5:$PERL5LIB"
      done
    '';

    meta = apparmor-meta "user-land utilities";
  };

  apparmor-bin-utils = stdenv.mkDerivation {
    name = "apparmor-bin-utils-${apparmor-version}";
    src = apparmor-sources;

    nativeBuildInputs = [
      pkgconfig
      libapparmor
      gawk
      which
    ];

    buildInputs = [
      libapparmor
    ];

    prePatch = prePatchCommon;
    postPatch = "cd ./binutils";
    makeFlags = ''LANGS= USE_SYSTEM=1'';
    installFlags = ''DESTDIR=$(out) BINDIR=$(out)/bin'';

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
    '';
    inherit patches;
    postPatch = "cd ./parser";
    makeFlags = ''LANGS= USE_SYSTEM=1 INCLUDEDIR=${libapparmor}/include'';
    installFlags = ''DESTDIR=$(out) DISTRO=unknown'';

    meta = apparmor-meta "rule parser";
  };

  apparmor-pam = stdenv.mkDerivation {
    name = "apparmor-pam-${apparmor-version}";
    src = apparmor-sources;

    nativeBuildInputs = [ pkgconfig which ];

    buildInputs = [ libapparmor pam ];

    postPatch = "cd ./changehat/pam_apparmor";
    makeFlags = ''USE_SYSTEM=1'';
    installFlags = ''DESTDIR=$(out)'';

    meta = apparmor-meta "PAM service";
  };

  apparmor-profiles = stdenv.mkDerivation {
    name = "apparmor-profiles-${apparmor-version}";
    src = apparmor-sources;

    nativeBuildInputs = [ which ];

    postPatch = "cd ./profiles";
    installFlags = ''DESTDIR=$(out) EXTRAS_DEST=$(out)/share/apparmor/extra-profiles'';

    meta = apparmor-meta "profiles";
  };

  apparmor-kernel-patches = stdenv.mkDerivation {
    name = "apparmor-kernel-patches-${apparmor-version}";
    src = apparmor-sources;

    phases = ''unpackPhase installPhase'';

    installPhase = ''
      mkdir "$out"
      cp -R ./kernel-patches/* "$out"
    '';

    meta = apparmor-meta "kernel patches";
  };

in

{
  inherit
    libapparmor
    apparmor-utils
    apparmor-bin-utils
    apparmor-parser
    apparmor-pam
    apparmor-profiles
    apparmor-kernel-patches;
}
