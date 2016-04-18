{ stdenv, fetchurl, makeWrapper, autoreconfHook
, pkgconfig, which
, flex, bison
, linuxHeaders ? stdenv.cc.libc.linuxHeaders
, pythonPackages
, perl
, swig
, pam
}:

let
  apparmor-series = "2.10";
  apparmor-version = apparmor-series;

  apparmor-meta = component: with stdenv.lib; {
    homepage = http://apparmor.net/;
    description = "A mandatory access control system - ${component}";
    license = licenses.gpl2;
    maintainers = with maintainers; [ phreedom thoughtpolice joachifm ];
    platforms = platforms.linux;
  };

  apparmor-sources = fetchurl {
    url = "https://launchpad.net/apparmor/${apparmor-series}/${apparmor-version}/+download/apparmor-${apparmor-version}.tar.gz";
    sha256 = "1x06qmmbha9krx7880pxj2k3l8fxy3nm945xjjv735m2ax1243jd";
  };

  prePatchCommon = ''
    substituteInPlace ./common/Make.rules --replace "/usr/bin/pod2man" "${perl}/bin/pod2man"
    substituteInPlace ./common/Make.rules --replace "/usr/bin/pod2html" "${perl}/bin/pod2html"
    substituteInPlace ./common/Make.rules --replace "/usr/include/linux/capability.h" "${linuxHeaders}/include/linux/capability.h"
    substituteInPlace ./common/Make.rules --replace "/usr/share/man" "share/man"
  '';

  libapparmor = stdenv.mkDerivation {
    name = "libapparmor-${apparmor-version}";
    src = apparmor-sources;

    nativeBuildInputs = [
      autoreconfHook
      bison
      flex
      pkgconfig
      swig
      which
    ];

    buildInputs = [
      perl
      pythonPackages.python
    ];

    # required to build apparmor-parser
    dontDisableStatic = true;

    prePatch = prePatchCommon + ''
      substituteInPlace ./libraries/libapparmor/src/Makefile.am --replace "/usr/include/netinet/in.h" "${stdenv.cc.libc.dev}/include/netinet/in.h"
      substituteInPlace ./libraries/libapparmor/src/Makefile.in --replace "/usr/include/netinet/in.h" "${stdenv.cc.libc.dev}/include/netinet/in.h"
    '';

    postPatch = "cd ./libraries/libapparmor";
    configureFlags = "--with-python --with-perl";

    meta = apparmor-meta "library";
  };

  apparmor-utils = stdenv.mkDerivation {
    name = "apparmor-utils-${apparmor-version}";
    src = apparmor-sources;

    nativeBuildInputs = [ makeWrapper which ];

    buildInputs = [
      perl
      pythonPackages.python
      pythonPackages.readline
      libapparmor
    ];

    prePatch = prePatchCommon;
    postPatch = "cd ./utils";
    makeFlags = ''LANGS='';
    installFlags = ''DESTDIR=$(out) BINDIR=$(out)/bin VIM_INSTALL_PATH=$(out)/share PYPREFIX='';

    postInstall = ''
      for prog in aa-audit aa-autodep aa-cleanprof aa-complain aa-disable aa-enforce aa-genprof aa-logprof aa-mergeprof aa-status aa-unconfined ; do
        wrapProgram $out/bin/$prog --prefix PYTHONPATH : "$out/lib/${pythonPackages.python.libPrefix}/site-packages:$PYTHONPATH"
      done

      for prog in aa-exec aa-notify ; do
        wrapProgram $out/bin/$prog --prefix PERL5LIB : "${libapparmor}/lib/perl5:$PERL5LIB"
      done
    '';

    meta = apparmor-meta "user-land utilities";
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
  inherit libapparmor apparmor-utils apparmor-parser apparmor-pam
  apparmor-profiles apparmor-kernel-patches;
}
