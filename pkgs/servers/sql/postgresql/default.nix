{ lib, stdenv, glibc, fetchurl, zlib, readline, libossp_uuid, openssl, makeWrapper }:

let

  common = { version, sha256, psqlSchema } @ args:
   let atLeast = lib.versionAtLeast version; in stdenv.mkDerivation (rec {
    name = "postgresql-${version}";

    src = fetchurl {
      url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
      inherit sha256;
    };

    outputs = [ "out" "lib" "doc" ];
    setOutputFlags = false; # $out retains configureFlags :-/

    buildInputs =
      [ zlib readline openssl makeWrapper ]
      ++ lib.optionals (!stdenv.isDarwin) [ libossp_uuid ];

    enableParallelBuilding = true;

    makeFlags = [ "world" ];

    configureFlags = [
      "--with-openssl"
      "--sysconfdir=/etc"
      "--libdir=$(lib)/lib"
    ]
      ++ lib.optional (stdenv.isDarwin)  "--with-uuid=e2fs"
      ++ lib.optional (!stdenv.isDarwin) "--with-ossp-uuid";

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
      '';

    postFixup =
      ''
        # initdb needs access to "locale" command from glibc.
        wrapProgram $out/bin/initdb --prefix PATH ":" ${glibc.bin}/bin
      '';

    disallowedReferences = [ stdenv.cc ];

    passthru = {
      inherit readline psqlSchema;
    };

    meta = with lib; {
      homepage = http://www.postgresql.org/;
      description = "A powerful, open source object-relational database system";
      license = licenses.postgresql;
      maintainers = [ maintainers.ocharles ];
      platforms = platforms.unix;
      hydraPlatforms = platforms.linux;
    };
  });

in {

  postgresql91 = common {
    version = "9.1.23";
    psqlSchema = "9.1";
    sha256 = "1mgnfm65fspkq62skfy48rjkprnxcfhydw0x3ipp4sdkngl72x3z";
  };

  postgresql92 = common {
    version = "9.2.18";
    psqlSchema = "9.2";
    sha256 = "1x1mxbwqvgj9s4y8pb4vv6fmmr36z5zl3b2ggb84ckdfhvakganp";
  };

  postgresql93 = common {
    version = "9.3.14";
    psqlSchema = "9.3";
    sha256 = "1783kl0abf9az90mvs08pdh63d33cv2njc1q515zz89bqkqj4hsw";
  };

  postgresql94 = common {
    version = "9.4.9";
    psqlSchema = "9.4";
    sha256 = "1jg1l6vrfwhfyqrx07bgcpqxb5zcp8zwm8qd2vcj0k11j0pac861";
  };

  postgresql95 = common {
    version = "9.5.4";
    psqlSchema = "9.5";
    sha256 = "1l3fqxlpxgl6nrcd4h6lpi2hsiv56yg83n3xrn704rmdch8mfpng";
  };

  postgresql96 = common {
    version = "9.6.1";
    psqlSchema = "9.6";
    sha256 = "1k8zwnabsl8f7vlp3azm4lrklkb9jkaxmihqf0mc27ql9451w475";
  };

}
