{ lib, stdenv
, build2
, fetchurl
, libbpkg
, libbutl
, libodb
, libodb-sqlite
, enableShared ? !stdenv.hostPlatform.isStatic
, enableStatic ? !enableShared
}:

stdenv.mkDerivation rec {
  pname = "bdep";
  version = "0.13.0";

  outputs = [ "out" "doc" "man" ];
  src = fetchurl {
    url = "https://pkg.cppget.org/1/alpha/build2/bdep-${version}.tar.gz";
    sha256 = "8e11b469d875d05c4eb7a228416b78a61c68a49310e5e41db78ed6d048f6ba2a";
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
    # https://build2.org/bdep/doc/bdep.xhtml
    longDescription = ''
      The build2 project dependency manager is used to manage the dependencies
      of a project during development.
    '';
    homepage = "https://build2.org/";
    changelog = "https://git.build2.org/cgit/bdep/tree/NEWS";
    license = licenses.mit;
    maintainers = with maintainers; [ r-burns ];
  };
}
