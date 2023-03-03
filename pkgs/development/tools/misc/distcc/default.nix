{ lib, stdenv, fetchFromGitHub, popt, avahi, pkg-config, python3, gtk3, runCommand
, gcc, autoconf, automake, which, procps, libiberty_static
, runtimeShell
, sysconfDir ? ""   # set this parameter to override the default value $out/etc
, static ? false
}:

let
  pname = "distcc";
  version = "2021-03-11";
  distcc = stdenv.mkDerivation {
    inherit pname version;
    src = fetchFromGitHub {
      owner = "distcc";
      repo = "distcc";
      rev = "de21b1a43737fbcf47967a706dab4c60521dbbb1";
      sha256 = "0zjba1090awxkmgifr9jnjkxf41zhzc4f6mrnbayn3v6s77ca9x4";
    };

    nativeBuildInputs = [ pkg-config autoconf automake ];
    buildInputs = [popt avahi python3 gtk3 which procps libiberty_static];
    preConfigure =
    ''
      export CPATH=$(ls -d ${gcc.cc}/lib/gcc/*/${gcc.cc.version}/plugin/include)

      configureFlagsArray=( CFLAGS="-O2 -fno-strict-aliasing"
                            CXXFLAGS="-O2 -fno-strict-aliasing"
          --mandir=$out/share/man
                            ${if sysconfDir == "" then "" else "--sysconfdir=${sysconfDir}"}
                            ${lib.optionalString static "LDFLAGS=-static"}
                            ${lib.withFeature (static == true || popt == null) "included-popt"}
                            ${lib.withFeature (avahi != null) "avahi"}
                            ${lib.withFeature (gtk3 != null) "gtk"}
                            --without-gnome
                            --enable-rfc2553
                            --disable-Werror   # a must on gcc 4.6
                           )
      installFlags="sysconfdir=$out/etc";

      ./autogen.sh
    '';

    # The test suite fails because it uses hard-coded paths, i.e. /usr/bin/gcc.
    doCheck = false;

    passthru = {
      # A derivation that provides gcc and g++ commands, but that
      # will end up calling distcc for the given cacheDir
      #
      # extraConfig is meant to be sh lines exporting environment
      # variables like DISTCC_HOSTS, DISTCC_DIR, ...
      links = extraConfig: (runCommand "distcc-links" { passthru.gcc = gcc.cc; }
        ''
          mkdir -p $out/bin
          if [ -x "${gcc.cc}/bin/gcc" ]; then
            cat > $out/bin/gcc << EOF
            #!${runtimeShell}
            ${extraConfig}
            exec ${distcc}/bin/distcc gcc "\$@"
          EOF
            chmod +x $out/bin/gcc
          fi
          if [ -x "${gcc.cc}/bin/g++" ]; then
            cat > $out/bin/g++ << EOF
            #!${runtimeShell}
            ${extraConfig}
            exec ${distcc}/bin/distcc g++ "\$@"
          EOF
            chmod +x $out/bin/g++
          fi
        '');
    };

    meta = {
      description = "A fast, free distributed C/C++ compiler";
      homepage = "http://distcc.org";
      license = "GPL";

      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [ anderspapitto ];
    };
  };
in
  distcc
