{ lib, stdenv, glibc, fetchurl, zlib, readline, libossp_uuid, openssl, libxml2, makeWrapper, tzdata }:

let

  common = { version, sha256, psqlSchema }:
   let atLeast = lib.versionAtLeast version; in stdenv.mkDerivation (rec {
    name = "postgresql-${version}";

    src = fetchurl {
      url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
      inherit sha256;
    };

    outputs = [ "out" "lib" "doc" "man" ];
    setOutputFlags = false; # $out retains configureFlags :-/

    buildInputs =
      [ zlib readline openssl libxml2 makeWrapper ]
      ++ lib.optionals (!stdenv.isDarwin) [ libossp_uuid ];

    enableParallelBuilding = true;

    makeFlags = [ "world" ];

    NIX_CFLAGS_COMPILE = [ "-I${libxml2.dev}/include/libxml2" ];

    configureFlags = [
      "--with-openssl"
      "--with-libxml"
      "--sysconfdir=/etc"
      "--libdir=$(lib)/lib"
      "--with-system-tzdata=${tzdata}/share/zoneinfo"
      (if stdenv.isDarwin then "--with-uuid=e2fs" else "--with-ossp-uuid")
    ];

    patches =
      [ (if atLeast "9.4" then ./disable-resolve_symlinks-94.patch else ./disable-resolve_symlinks.patch)
        (if atLeast "9.6" then ./less-is-more-96.patch             else ./less-is-more.patch)
        (if atLeast "9.6" then ./hardcode-pgxs-path-96.patch       else ./hardcode-pgxs-path.patch)
        ./specify_pkglibdir_at_runtime.patch
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

        # Prevent a retained dependency on gcc-wrapper.
        substituteInPlace "$out/lib/pgxs/src/Makefile.global" --replace ${stdenv.cc}/bin/ld ld

        if [ -z "''${dontDisableStatic:-}" ]; then
          # Remove static libraries in case dynamic are available.
          for i in $out/lib/*.a; do
            name="$(basename "$i")"
            if [ -e "$lib/lib/''${name%.a}.so" ] || [ -e "''${i%.a}.so" ]; then
              rm "$i"
            fi
          done
        fi
      '';

    postFixup = lib.optionalString (!stdenv.isDarwin && stdenv.hostPlatform.libc == "glibc")
      ''
        # initdb needs access to "locale" command from glibc.
        wrapProgram $out/bin/initdb --prefix PATH ":" ${glibc.bin}/bin
      '';

    doInstallCheck = false; # needs a running daemon?

    disallowedReferences = [ stdenv.cc ];

    passthru = {
      inherit readline psqlSchema;
    };

    meta = with lib; {
      homepage = https://www.postgresql.org;
      description = "A powerful, open source object-relational database system";
      license = licenses.postgresql;
      maintainers = [ maintainers.ocharles ];
      platforms = platforms.unix;
    };
  });

in {

  postgresql93 = common {
    version = "9.3.23";
    psqlSchema = "9.3";
    sha256 = "1jzncs7b6zrcgpnqjbjcc4y8303a96zqi3h31d3ix1g3vh31160x";
  };

  postgresql94 = common {
    version = "9.4.18";
    psqlSchema = "9.4";
    sha256 = "1h64yjyrlz3ppsp9k6sm4jihg6n9i7mqhkx4p0hymqzmnbr3g0s2";
  };

  postgresql95 = common {
    version = "9.5.13";
    psqlSchema = "9.5";
    sha256 = "1vm55q9apja6lg672m9xl1zq3iwv2zwnn0d0qr003zan1dmbh22l";
  };

  postgresql96 = common {
    version = "9.6.9";
    psqlSchema = "9.6";
    sha256 = "0biy8j69dbvdmrag55pdszpc0702agzqhhcwdx21xp02mzim4ydr";
  };

  postgresql100 = common {
    version = "10.4";
    psqlSchema = "10.0";
    sha256 = "0j000bcs9w8wrllg8m7j1lxsd3n2x0yzkack5p35cmxx20iq2q0v";
  };

}
