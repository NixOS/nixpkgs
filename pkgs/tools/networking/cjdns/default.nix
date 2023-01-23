{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, nodejs
, which
, python39
, libuv
, util-linux
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "cjdns";
  version = "21.4";

  src = fetchFromGitHub {
    owner = "cjdelisle";
    repo = "cjdns";
    rev = "cjdns-v${version}";
    sha256 = "sha256-vI3uHZwmbFqxGasKqgCl0PLEEO8RNEhwkn5ZA8K7bxU=";
  };

  cargoSha256 = "sha256-x3LxGOhGXrheqdke0eYiQVo/IqgWgcDrDNupdLjRPjA=";

  nativeBuildInputs = [
    which
    python39
    nodejs
  ] ++
    # for flock
    lib.optional stdenv.isLinux util-linux;

  buildInputs = [
    libuv
  ];

  NIX_CFLAGS_COMPILE = [
    "-O2"
    "-Wno-error=array-bounds"
    "-Wno-error=stringop-overflow"
    "-Wno-error=stringop-truncation"
  ] ++ lib.optionals (stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "11") [
    "-Wno-error=stringop-overread"
  ];

  passthru.tests.basic = nixosTests.cjdns;

  meta = with lib; {
    homepage = "https://github.com/cjdelisle/cjdns";
    description = "Encrypted networking for regular people";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ehmry ];
    platforms = platforms.linux;
  };
}
