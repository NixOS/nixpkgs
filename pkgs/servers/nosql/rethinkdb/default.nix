{
  lib,
  stdenv,
  fetchurl,
  which,
  m4,
  protobuf,
  boost,
  zlib,
  curl,
  openssl,
  icu,
  jemalloc,
  libtool,
  python3Packages,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "rethinkdb";
  version = "2.4.4";

  src = fetchurl {
    url = "https://download.rethinkdb.com/repository/raw/dist/${pname}-${version}.tgz";
    hash = "sha256-UJEjdgK2KDDbLLParKarNGMjI3QeZxDC8N5NhPRCcR8=";
  };

  postPatch = ''
    substituteInPlace external/quickjs_*/Makefile \
      --replace "gcc-ar" "${stdenv.cc.targetPrefix}ar" \
      --replace "gcc" "${stdenv.cc.targetPrefix}cc"
  '';

  preConfigure = ''
    export ALLOW_WARNINGS=1
    patchShebangs .
  '';

  configureFlags = lib.optionals (!stdenv.isDarwin) [
    "--with-jemalloc"
    "--lib-path=${jemalloc}/lib"
  ];

  makeFlags = [ "rethinkdb" ];

  buildInputs =
    [
      protobuf
      boost
      zlib
      curl
      openssl
      icu
    ]
    ++ lib.optional (!stdenv.isDarwin) jemalloc
    ++ lib.optional stdenv.isDarwin libtool;

  nativeBuildInputs = [
    which
    m4
    python3Packages.python
    makeWrapper
  ];

  enableParallelBuilding = true;

  postInstall = ''
    wrapProgram $out/bin/rethinkdb \
      --prefix PATH ":" "${python3Packages.rethinkdb}/bin"
  '';

  meta = {
    description = "An open-source distributed database built with love";
    mainProgram = "rethinkdb";
    longDescription = ''
      RethinkDB is built to store JSON documents, and scale to
      multiple machines with very little effort. It has a pleasant
      query language that supports really useful queries like table
      joins and group by, and is easy to setup and learn.
    '';
    homepage = "https://rethinkdb.com";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      thoughtpolice
      bluescreen303
    ];
  };
}
