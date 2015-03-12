{ stdenv, fetchurl, autoconf, automake, libtool, pkgconfig, perl, which
, glibc, flex, bison, python27, swig, dbus, pam
}:

let
  apparmor-series = "2.9";
  apparmor-patchver = "1";
  apparmor-version = "${apparmor-series}.${apparmor-patchver}";

  apparmor-meta = component: with stdenv.lib; {
      homepage = http://apparmor.net/;
      description = "Linux application security system - ${component}";
      license = licenses.gpl2;
      maintainers = with maintainers; [ phreedom thoughtpolice joachifm ];
      platforms = platforms.linux;
  };

  apparmor-sources = fetchurl {
    url = "https://launchpad.net/apparmor/${apparmor-series}/${apparmor-version}/+download/apparmor-${apparmor-version}.tar.gz";
    sha256 = "a63b8724c36c29ed438c9e3ca403bfeeb6c998a45990e300aa1b10faa23a0a22";
  };

  libapparmor = stdenv.mkDerivation {
    name = "libapparmor-${apparmor-version}";
    src = apparmor-sources;

    buildInputs = [
      autoconf
      automake
      bison
      flex
      dbus # requires patch to dbus ...
      glibc
      libtool
      perl
      pkgconfig
      python27
      swig
      which
    ];

    prePatch = ''
      ### common
      substituteInPlace ./common/Make.rules --replace "/usr/bin/pod2man" "${perl}/bin/pod2man"
      substituteInPlace ./common/Make.rules --replace "/usr/bin/pod2html" "${perl}/bin/pod2html"
      substituteInPlace ./common/Make.rules --replace "/usr/include/linux/capability.h" "${glibc}/include/linux/capability.h"

      ### libapparmor
      substituteInPlace ./libraries/libapparmor/src/Makefile.am --replace "/usr/include/netinet/in.h" "${glibc}/include/netinet/in.h"
      substituteInPlace ./libraries/libapparmor/src/Makefile.in --replace "/usr/include/netinet/in.h" "${glibc}/include/netinet/in.h"
      '';

    buildPhase = ''
      ### libapparmor
      cd ./libraries/libapparmor
      ./autogen.sh
      ./configure --prefix="$out" --with-python
      make
      '';

    installPhase = ''
      make install
    '';

    meta = apparmor-meta "library";
  };

  apparmor-utils = stdenv.mkDerivation {
    name = "apparmor-utils-${apparmor-version}";
    src = apparmor-sources;

    buildInputs = [
      python27
      libapparmor
      which
    ];

    prePatch = ''
      ### common
      substituteInPlace ./common/Make.rules --replace "/usr/bin/pod2man" "${perl}/bin/pod2man"
      substituteInPlace ./common/Make.rules --replace "/usr/bin/pod2html" "${perl}/bin/pod2html"
      substituteInPlace ./common/Make.rules --replace "/usr/include/linux/capability.h" "${glibc}/include/linux/capability.h"
    '';

    buildPhase = ''
      cd ./utils
      make LANGS=""
    '';

    installPhase = ''
      make install LANGS="" DESTDIR="$out" BINDIR="$out/bin"
    '';

    meta = apparmor-meta "user-land utilities";
  };

  apparmor-parser = stdenv.mkDerivation {
    name = "apparmor-parser-${apparmor-version}";
    src = apparmor-sources;

    buildInputs = [
      libapparmor
      bison
      flex
      which
    ];

    prePatch = ''
      ### common
      substituteInPlace ./common/Make.rules --replace "/usr/bin/pod2man" "${perl}/bin/pod2man"
      substituteInPlace ./common/Make.rules --replace "/usr/bin/pod2html" "${perl}/bin/pod2html"
      substituteInPlace ./common/Make.rules --replace "/usr/include/linux/capability.h" "${glibc}/include/linux/capability.h"

      ### apparmor-parser
      substituteInPlace ./parser/Makefile --replace "/usr/bin/bison" "${bison}/bin/bison"
      substituteInPlace ./parser/Makefile --replace "/usr/bin/flex" "${flex}/bin/flex"
      substituteInPlace ./parser/Makefile --replace "/usr/include/linux/capability.h" "${glibc}/include/linux/capability.h"
      ## techdoc.pdf still doesn't build ...
      substituteInPlace ./parser/Makefile --replace "manpages htmlmanpages pdf" "manpages htmlmanpages"
    '';

    buildPhase = ''
      cd ./parser
      make LANGS="" USE_SYSTEM=1 INCLUDEDIR=${libapparmor}/include
    '';

    installPhase = ''
      make install LANGS="" USE_SYSTEM=1 INCLUDEDIR=${libapparmor}/include DESTDIR="$out" DISTRO="unknown"
    '';

    meta = apparmor-meta "rule parser";
  };

  apparmor-pam = stdenv.mkDerivation {
    name = "apparmor-pam-${apparmor-version}";
    src = apparmor-sources;

    buildInputs = [
      libapparmor
      pam
      pkgconfig
      which
    ];

    buildPhase = ''
      cd ./changehat/pam_apparmor
      make USE_SYSTEM=1
    '';

    installPhase = ''
      make install DESTDIR="$out"
    '';

    meta = apparmor-meta "PAM service";
  };

  apparmor-profiles = stdenv.mkDerivation {
    name = "apparmor-profiles-${apparmor-version}";
    src = apparmor-sources;

    buildInputs = [
      which
    ];

    buildPhase = ''
      cd ./profiles
      make
    '';

    installPhase = ''
      make install DESTDIR="$out"
    '';

    meta = apparmor-meta "profiles";
  };

  apparmor-kernel-patches = stdenv.mkDerivation {
    name = "apparmor-kernel-patches-${apparmor-version}";
    src = apparmor-sources;

    phases = ''unpackPhase installPhase'';

    installPhase = ''
      mkdir "$out"
      cp -R ./kernel-patches "$out"
    '';

    meta = apparmor-meta "kernel patches";
  };

in

{
  inherit libapparmor apparmor-utils apparmor-parser apparmor-pam
  apparmor-profiles apparmor-kernel-patches;
}
