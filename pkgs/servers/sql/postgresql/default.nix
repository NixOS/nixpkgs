{ lib, stdenv, fetchurl, zlib, readline, libossp_uuid, openssl }:

let

  common = { version, sha256, psqlSchema } @ args: stdenv.mkDerivation (rec {
    name = "postgresql-${version}";

    src = fetchurl {
      url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
      inherit sha256;
    };

    outputs = [ "out" "doc" ];

    buildInputs =
      [ zlib readline openssl ]
      ++ lib.optionals (!stdenv.isDarwin) [ libossp_uuid ];

    enableParallelBuilding = true;

    makeFlags = [ "world" ];

    configureFlags =
      [ "--with-openssl" ]
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
        # Prevent a retained dependency on gcc-wrapper.
        substituteInPlace $out/lib/pgxs/src/Makefile.global --replace ${stdenv.cc}/bin/ld ld
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

  postgresql90 = common {
    version = "9.0.22";
    psqlSchema = "9.0";
    sha256 = "19gq6axjhvlr5zlrzwnll1fbrvai4xh0nb1jki6gmmschl6v5m4l";
  };

  postgresql91 = common {
    version = "9.1.18";
    psqlSchema = "9.1";
    sha256 = "1a44hmcvfaa8j169ladsibmvjakw6maaxqkzz1ab8139cqkda9i7";
  };

  postgresql92 = common {
    version = "9.2.13";
    psqlSchema = "9.2";
    sha256 = "0i3avdr8mnvn6ldkx0hc4jmclhisb2338hzs0j2m03wck8hddjsx";
  };

  postgresql93 = common {
    version = "9.3.9";
    psqlSchema = "9.3";
    sha256 = "0j85j69rf54cwz5yhrhk4ca22b82990j5sqb8cr1fl9843nd0fzp";
  };

  postgresql94 = common {
    version = "9.4.4";
    psqlSchema = "9.4";
    sha256 = "04q07g209y99xzjh88y52qpvz225rxwifv8nzp3bxzfni2bdk3jk";
  };

}
