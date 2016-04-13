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
    version = "9.1.20";
    psqlSchema = "9.1";
    sha256 = "0dr9hz1a0ax30f6jvnv2rck0zzxgk9x7nh4n1xgshrf26i1nq7kd";
  };

  postgresql92 = common {
    version = "9.2.15";
    psqlSchema = "9.2";
    sha256 = "0q1yahkfys78crf59avp02ibd0lp3z7h626xchyfi6cqb03livbw";
  };

  postgresql93 = common {
    version = "9.3.11";
    psqlSchema = "9.3";
    sha256 = "08ba951nfiy516flaw352shj1zslxg4ryx3w5k0adls1r682l8ix";
  };

  postgresql94 = common {
    version = "9.4.6";
    psqlSchema = "9.4";
    sha256 = "19j0845i195ksg9pvnk3yc2fr62i7ii2bqgbidfjq556056izknb";
  };

  postgresql95 = common {
    version = "9.5.1";
    psqlSchema = "9.5";
    sha256 = "1ljvijaja5zy4i5b1450drbj8m3fcm3ly1zzaakp75x30s2rsc3b";
  };


}
