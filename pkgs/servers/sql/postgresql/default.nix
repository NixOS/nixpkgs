{ lib, stdenv, fetchurl, zlib, readline, libossp_uuid, openssl }:

let

  common = { version, sha256, psqlSchema } @ args: stdenv.mkDerivation (rec {
    name = "postgresql-${version}";

    src = fetchurl {
      url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
      inherit sha256;
    };

    outputs = [ "out" "lib" "doc" ];
    setOutputFlags = false; # $out retains configureFlags :-/

    buildInputs =
      [ zlib readline openssl ]
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
      [ (if lib.versionAtLeast version "9.4" then ./disable-resolve_symlinks-94.patch else ./disable-resolve_symlinks.patch)
        ./less-is-more.patch
      ];

    installTargets = [ "install-world" ];

    LC_ALL = "C";

    postInstall =
      ''
        moveToOutput "lib/pgxs" "$out" # looks strange, but not deleting it
        moveToOutput "lib/*.a" "$out"
        moveToOutput "lib/libecpg*" "$out"

        # Prevent a retained dependency on gcc-wrapper.
        substituteInPlace "$out/lib/pgxs/src/Makefile.global" --replace ${stdenv.cc}/bin/ld ld
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
    version = "9.1.21";
    psqlSchema = "9.1";
    sha256 = "14xkvv7ph7yh399wppqpil9lgh1vw53nyg5ynk5a8j9idw3yjvnn";
  };

  postgresql92 = common {
    version = "9.2.16";
    psqlSchema = "9.2";
    sha256 = "048vfkq58kkhcrw5vj4vplgvxia1k0lrbhbi30b2iy3bf2w4q5nj";
  };

  postgresql93 = common {
    version = "9.3.12";
    psqlSchema = "9.3";
    sha256 = "0rrf24mw68lwxjjnbbaayizhhcylwnr7ij5d60vpzl467yi9wczk";
  };

  postgresql94 = common {
    version = "9.4.7";
    psqlSchema = "9.4";
    sha256 = "1q41bwwa4x1ff2qzlrsfia25ys5gfrihbqwib1z6j3mk6mn5wyfc";
  };

  postgresql95 = common {
    version = "9.5.2";
    psqlSchema = "9.5";
    sha256 = "0hbwwhh0pz0a6vf8j5bskiq7gmz9rwc9ywcqyhg5asshckj35lgq";
  };


}
