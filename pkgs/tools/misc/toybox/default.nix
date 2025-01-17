{
  stdenv,
  lib,
  fetchFromGitHub,
  which,
  buildPackages,
  libxcrypt,
  libiconv,
  enableStatic ? stdenv.hostPlatform.isStatic,
  enableMinimal ? false,
  extraConfig ? "",
}:

let
  inherit (lib) optionals;
in

stdenv.mkDerivation rec {
  pname = "toybox";
  version = "0.8.11";

  src = fetchFromGitHub {
    owner = "landley";
    repo = pname;
    rev = version;
    sha256 = "sha256-7izs2C5/czec0Dt3apL8s7luARAlw4PfUFy9Xsxb0zw=";
  };

  depsBuildBuild = optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    buildPackages.stdenv.cc
  ];
  buildInputs =
    [
      libxcrypt
    ]
    ++ optionals stdenv.hostPlatform.isDarwin [
      libiconv
    ]
    ++ optionals (enableStatic && stdenv.cc.libc ? static) [
      stdenv.cc.libc
      stdenv.cc.libc.static
    ];

  postPatch = "patchShebangs .";

  inherit extraConfig;
  passAsFile = [ "extraConfig" ];

  configurePhase = ''
    make ${
      if enableMinimal then
        "allnoconfig"
      else if stdenv.hostPlatform.isFreeBSD then
        "freebsd_defconfig"
      else if stdenv.hostPlatform.isDarwin then
        "macos_defconfig"
      else
        "defconfig"
    }

    cat $extraConfigPath .config > .config-
    mv .config- .config

    make oldconfig
  '';

  makeFlags = [ "PREFIX=$(out)/bin" ] ++ optionals enableStatic [ "LDFLAGS=--static" ];

  installTargets = [ "install_flat" ];

  # tests currently (as of 0.8.0) get stuck in an infinite loop...
  # ...this is fixed in latest git, so doCheck can likely be enabled for next release
  # see https://github.com/landley/toybox/commit/b928ec480cd73fd83511c0f5ca786d1b9f3167c3
  #doCheck = true;
  nativeCheckInputs = [ which ]; # used for tests with checkFlags = [ "DEBUG=true" ];
  checkTarget = "tests";

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  meta = with lib; {
    description = "Lightweight implementation of some Unix command line utilities";
    homepage = "https://landley.net/toybox/";
    license = licenses.bsd0;
    platforms = with platforms; linux ++ darwin ++ freebsd;
    maintainers = with maintainers; [ hhm ];
    priority = 10;
  };
}
