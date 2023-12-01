{ stdenv
, lib
, fetchgit
, openssl
, enableShared ? !stdenv.hostPlatform.isStatic
, enableManpages ? false
, pandoc
}:

stdenv.mkDerivation rec {
  pname = "fsverity-utils";
  version = "1.5";

  outputs = [ "out" "lib" "dev" ] ++ lib.optional enableManpages "man";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/fsverity-utils.git";
    rev = "v${version}";
    sha256 = "sha256-ygBOkp2PBe8Z2ak6SXEJ6HHuT4NRKmIsbJDHcY+h8PQ=";
  };

  patches = lib.optionals (!enableShared) [
    ./remove-dynamic-libs.patch
  ];

  enableParallelBuilding = true;
  strictDeps = true;

  nativeBuildInputs = lib.optional enableManpages pandoc;
  buildInputs = [ openssl ];

  makeFlags = [ "DESTDIR=$(out)" "PREFIX=" ] ++ lib.optional enableShared "USE_SHARED_LIB=1";

  doCheck = true;

  installTargets = [ "install" ] ++ lib.optional enableManpages "install-man";

  postInstall = ''
    mkdir -p $lib
    mv $out/lib $lib/lib
  '';

  meta = with lib; {
    homepage = "https://www.kernel.org/doc/html/latest/filesystems/fsverity.html#userspace-utility";
    changelog = "https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/fsverity-utils.git/tree/NEWS.md";
    description = "A set of userspace utilities for fs-verity";
    license = licenses.mit;
    maintainers = with maintainers; [ jk ];
    platforms = platforms.linux;
  };
}
