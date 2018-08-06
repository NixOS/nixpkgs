{ stdenv, lib, fetchurl, makeWrapper
, glibc, zlib, readline, libossp_uuid, openssl, libxml2, tzdata, systemd

# Gate JIT support right now behind a flag; it increases closure size
# dramatically due to the PostgreSQL build system requiring a hard dependency
# on clang-wrapper (~140MB -> 1.4GB). This must be worked around before it can
# be enabled by default by making clang-wrapper a build-time only dependency.
, llvmPackages, enableJitSupport ? false
}@deps:

let

  common = { version, sha256, psqlSchema }:
   let
     atLeast = lib.versionAtLeast version;

     # JIT is only supported on Linux, for now. (Darwin may build, but must be
     # tested).
     jitEnabled = atLeast "11" && enableJitSupport && deps.stdenv.isLinux;

     # Note: use deps.stdenv, not just 'stdenv', otherwise infinite recursion
     # will occur due to lexical scoping rules.
     stdenv = if jitEnabled then llvmPackages.stdenv else deps.stdenv;
   in stdenv.mkDerivation (rec {
    name = "postgresql-${version}";
    inherit version;

    src = fetchurl {
      url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
      inherit sha256;
    };

    outputs = [ "out" "lib" "doc" "man" ];
    setOutputFlags = false; # $out retains configureFlags :-/

    buildInputs =
      [ zlib readline openssl libxml2 makeWrapper ]
      ++ lib.optionals (!stdenv.isDarwin) [ libossp_uuid ]
      ++ lib.optionals (atLeast "9.6" && !stdenv.isDarwin) [ systemd ]
      ++ lib.optionals jitEnabled (with llvmPackages; [ clang llvm ]);

    enableParallelBuilding = true;

    makeFlags = [ "world" ];

    NIX_CFLAGS_COMPILE = [ "-I${libxml2.dev}/include/libxml2" ];

    # Otherwise it retains a reference to compiler and fails; see #44767.  TODO: better.
    preConfigure = "CC=${stdenv.cc.targetPrefix}cc";

    configureFlags = [
      "--with-openssl"
      "--with-libxml"
      "--sysconfdir=/etc"
      "--libdir=$(lib)/lib"
      "--with-system-tzdata=${tzdata}/share/zoneinfo"
      (lib.optionalString (atLeast "9.6" && !stdenv.isDarwin) "--with-systemd")
      (if stdenv.isDarwin then "--with-uuid=e2fs" else "--with-ossp-uuid")
      (lib.optionalString jitEnabled "--with-llvm")
    ];

    patches =
      [ (if atLeast "9.4" then ./patches/disable-resolve_symlinks-94.patch else ./patches/disable-resolve_symlinks.patch)
        (if atLeast "9.6" then ./patches/less-is-more-96.patch             else ./patches/less-is-more.patch)
        (if atLeast "9.6" then ./patches/hardcode-pgxs-path-96.patch       else ./patches/hardcode-pgxs-path.patch)
        ./patches/specify_pkglibdir_at_runtime.patch
      ];

    installTargets = [ "install-world" ];

    LC_ALL = "C";

    postConfigure =
      let path = if atLeast "9.6" then "src/common/config_info.c" else "src/bin/pg_config/pg_config.c"; in
        ''
          # Hardcode the path to pgxs so pg_config returns the path in $out
          substituteInPlace "${path}" --replace HARDCODED_PGXS_PATH $out/lib
        '';

    postInstall =
      ''
        moveToOutput "lib/pgxs" "$out" # looks strange, but not deleting it
        moveToOutput "lib/*.a" "$out"
        moveToOutput "lib/libecpg*" "$out"

        if [ -z "''${dontDisableStatic:-}" ]; then
          # Remove static libraries in case dynamic are available.
          for i in $out/lib/*.a; do
            name="$(basename "$i")"
            if [ -e "$lib/lib/''${name%.a}.so" ] || [ -e "''${i%.a}.so" ]; then
              rm "$i"
            fi
          done
        fi

        # Prevent a retained dependency on gcc-wrapper.
        substituteInPlace "$out/lib/pgxs/src/Makefile.global" --replace ${stdenv.cc}/bin/ld ld
      '' + lib.optionalString jitEnabled ''
        # In the case of JIT support, prevent a retained dependency on clang-wrapper, too
        substituteInPlace "$out/lib/pgxs/src/Makefile.global" --replace ${stdenv.cc}/bin/clang clang

        # Move the bitcode and libllvmjit.so library out of $lib; otherwise, every client that
        # depends on libpq.so will also have libLLVM.so in its closure too, bloating it
        moveToOutput "lib/bitcode" "$out"
        moveToOutput "lib/llvmjit*" "$out"
      '';

    postFixup = lib.optionalString (!stdenv.isDarwin && stdenv.hostPlatform.libc == "glibc")
      ''
        # initdb needs access to "locale" command from glibc.
        wrapProgram $out/bin/initdb --prefix PATH ":" ${glibc.bin}/bin
      '';

    doInstallCheck = false; # needs a running daemon?

    disallowedReferences = [ stdenv.cc ];

    passthru = {
      # Note: we export 'stdenv', because the chosen stdenv *might* be a llvmPackages-based
      # one, and we want to propagate that to all extensions.
      inherit readline psqlSchema stdenv;
      compareVersion = builtins.compareVersions version;
      hasJitSupport  = jitEnabled;
    };

    meta = with lib; {
      description = "A powerful, open source object-relational database system";
      homepage    = https://www.postgresql.org;
      license     = licenses.postgresql;
      maintainers = with maintainers; [ ocharles thoughtpolice ];
      platforms   = platforms.unix;
    };
  });

in {

  postgresql93 = common {
    version = "9.3.24";
    psqlSchema = "9.3";
    sha256 = "1a8dnv16n2rxnbwhqw7c0kjpj3xqvkpwk50kvimj4d917cxaf542";
  };

  postgresql94 = common {
    version = "9.4.19";
    psqlSchema = "9.4";
    sha256 = "12qn9h47rkn4k41gdbxkkvg0pff43k1113jmhc83f19adc1nnxq3";
  };

  postgresql95 = common {
    version = "9.5.14";
    psqlSchema = "9.5";
    sha256 = "0k8s62h6qd9p3xlx315j5irniskqsnx1nz4ir5r1yhqp07mdab1y";
  };

  postgresql96 = common {
    version = "9.6.10";
    psqlSchema = "9.6";
    sha256 = "09l4zqs74fqnazdsyln9x657mq3wsbgng9wpvq71yh26cv2sq5c6";
  };

  # NOTE: starting with PostgreSQL 10, the versioning scheme changed from
  # <supermajor>.<major>.<minor> to <major>.<minor>. Thus there is no longer a
  # 3rd component, and we should name attributes following only the major
  # number.
  postgresql10 = common {
    version = "10.5";
    psqlSchema = "10.0";
    sha256 = "04a07jkvc5s6zgh6jr78149kcjmsxclizsqabjw44ld4j5n633kc";
  };

  postgresql11 = common {
    version    = "11beta2";
    psqlSchema = "11.0";
    sha256     = "0qxlfh1a7bhhamrbs3msk71pny7jxx0c0fs26zlmp7jjn138zqii";
  };
}
