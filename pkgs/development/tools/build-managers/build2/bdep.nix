{
  lib,
  stdenv,
  build2,
  fetchurl,
  libbpkg,
  libbutl,
  libodb,
  libodb-sqlite,
  enableShared ? !stdenv.hostPlatform.isStatic,
  enableStatic ? !enableShared,
}:

stdenv.mkDerivation rec {
  pname = "bdep";
  version = "0.17.0";

  outputs = [
    "out"
    "doc"
    "man"
  ];
  src = fetchurl {
    url = "https://pkg.cppget.org/1/alpha/build2/bdep-${version}.tar.gz";
    hash = "sha256-+2Hl5kanxWJmOpfePAvvSBSmG3kZLQv/kYIkT4J+kaQ=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    build2
  ];
  buildInputs = [
    libbpkg
    libbutl
    libodb
    libodb-sqlite
  ];

  build2ConfigureFlags = [
    "config.bin.lib=${build2.configSharedStatic enableShared enableStatic}"
  ];

  meta = with lib; {
    description = "build2 project dependency manager";
    mainProgram = "bdep";
    # https://build2.org/bdep/doc/bdep.xhtml
    longDescription = ''
      The build2 project dependency manager is used to manage the dependencies
      of a project during development.
    '';
    homepage = "https://build2.org/";
    changelog = "https://git.build2.org/cgit/bdep/tree/NEWS";
    license = licenses.mit;
    maintainers = with maintainers; [ r-burns ];
    platforms = platforms.all;
  };
}
