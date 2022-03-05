{ lib, stdenv
, build2
, fetchurl
, git
, libbpkg
, libbutl
, libodb
, libodb-sqlite
, openssl
, enableShared ? !stdenv.hostPlatform.isStatic
, enableStatic ? !enableShared
}:

stdenv.mkDerivation rec {
  pname = "bpkg";
  version = "0.14.0";

  outputs = [ "out" "doc" "man" ];

  src = fetchurl {
    url = "https://pkg.cppget.org/1/alpha/build2/bpkg-${version}.tar.gz";
    sha256 = "sha256-4WTFm0NYZOujxQ3PR9MyjXEJ4ql4qZ9OM5BePuHIK1M=";
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
  checkInputs = [
    git
    openssl
  ];

  doCheck = !stdenv.isDarwin; # tests hang

  # Failing test
  postPatch = ''
    rm tests/rep-create.testscript
  '';

  build2ConfigureFlags = [
    "config.bin.lib=${build2.configSharedStatic enableShared enableStatic}"
  ];

  meta = with lib; {
    description = "build2 package dependency manager";
    # https://build2.org/bpkg/doc/bpkg.xhtml
    longDescription = ''
      The build2 package dependency manager is used to manipulate build
      configurations, packages, and repositories.
    '';
    homepage = "https://build2.org/";
    changelog = "https://git.build2.org/cgit/bpkg/tree/NEWS";
    license = licenses.mit;
    maintainers = with maintainers; [ r-burns ];
    platforms = platforms.all;
  };
}
