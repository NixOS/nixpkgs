{ stdenv
, lib
, openssl
, zlib
, libkrb5
, icu
, postgresql
, pkg-config
, tzdata
, gssSupport ? !stdenv.hostPlatform.isWindows
}:

stdenv.mkDerivation {
  pname = "libpq";
  inherit (postgresql) src version;

  configureFlags = [
    "--with-openssl"
    "--with-icu"
    "--without-readline"
    "--with-system-tzdata=${tzdata}/share/zoneinfo"
    "--enable-debug"
  ]
  ++ lib.optionals gssSupport [ "--with-gssapi" ];

  nativeBuildInputs = [ pkg-config tzdata ];
  buildInputs = [ openssl zlib icu ]
    ++ lib.optional gssSupport libkrb5;

  enableParallelBuilding = !stdenv.isDarwin;

  separateDebugInfo = true;

  buildFlags = [ "submake-libpq" "submake-libpgport" ];

  installPhase = ''
    runHook preInstall

    make -C src/bin/pg_config install
    make -C src/common install
    make -C src/include install
    make -C src/interfaces/libpq install
    make -C src/port install

    moveToOutput "bin" "$dev"
    moveToOutput "lib/*.a" "$static"
    rm -rfv $out/share

    runHook postInstall
  '';

  outputs = [ "out" "dev" "static" ];

  meta = with lib; {
    homepage = "https://www.postgresql.org";
    description = "Client API library for PostgreSQL";
    license = licenses.postgresql;
    maintainers = with maintainers; [ szlend ];
    platforms = platforms.unix;
  };
}
