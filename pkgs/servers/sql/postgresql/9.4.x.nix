{ stdenv, fetchurl, zlib, readline, libossp_uuid, openssl }:

with stdenv.lib;

let version = "9.4.4"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "04q07g209y99xzjh88y52qpvz225rxwifv8nzp3bxzfni2bdk3jk";
  };

  outputs = [ "out" "doc" ];

  buildInputs = [ zlib readline openssl ]
                ++ optionals (!stdenv.isDarwin) [ libossp_uuid ];

  enableParallelBuilding = true;

  makeFlags = [ "world" ];

  configureFlags = [ "--with-openssl" ]
                   ++ optional (stdenv.isDarwin)  "--with-uuid=e2fs"
                   ++ optional (!stdenv.isDarwin) "--with-ossp-uuid";

  patches = [ ./disable-resolve_symlinks-94.patch ./less-is-more.patch ];

  installTargets = [ "install-world" ];

  LC_ALL = "C";

  postInstall =
    ''
      # Prevent a retained dependency on gcc-wrapper.
      substituteInPlace $out/lib/pgxs/src/Makefile.global --replace ${stdenv.cc}/bin/ld ld
    '';

  disallowedReferences = [ stdenv.cc ];

  passthru = {
    inherit readline;
    psqlSchema = "9.4";
  };

  meta = with stdenv.lib; {
    homepage = http://www.postgresql.org/;
    description = "A powerful, open source object-relational database system";
    license = licenses.postgresql;
    maintainers = [ maintainers.ocharles ];
    platforms = platforms.unix;
    hydraPlatforms = platforms.linux;
  };
}
