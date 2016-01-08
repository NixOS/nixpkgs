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
    version = "9.0.23";
    psqlSchema = "9.0";
    sha256 = "1pnpni95r0ry112z6ycrqk5m6iw0vd4npg789czrl4qlr0cvxg1x";
  };

  postgresql91 = common {
    version = "9.1.19";
    psqlSchema = "9.1";
    sha256 = "1ihf9h353agsm5p2dr717dvraxvsw6j7chbn3qxdcz8la5s0bmfb";
  };

  postgresql92 = common {
    version = "9.2.14";
    psqlSchema = "9.2";
    sha256 = "0bi9zfsfhj84mnaa41ar63j9qgzsnac1wwgjhy2c6j0a68zhphjl";
  };

  postgresql93 = common {
    version = "9.3.10";
    psqlSchema = "9.3";
    sha256 = "0c8mailildnqnndwpmnqf8ymxmk1qf5w5dq02hjqmydgfq7lyi75";
  };

  postgresql94 = common {
    version = "9.4.5";
    psqlSchema = "9.4";
    sha256 = "0faav7k3nlhh1z7j1r3adrhx1fpsji3jixmm2abjm93fdg350z5q";
  };

  postgresql95 = common {
    version = "9.5.0";
    psqlSchema = "9.5";
    sha256 = "f1c0d3a1a8aa8c92738cab0153fbfffcc4d4158b3fee84f7aa6bfea8283978bc";
  };


}
