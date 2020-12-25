{
  stdenv, lib, fetchFromGitHub, which,
  buildPackages,
  enableStatic ? false,
  enableMinimal ? false,
  extraConfig ? ""
}:

stdenv.mkDerivation rec {
  pname = "toybox";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "landley";
    repo = pname;
    rev = version;
    sha256 = "0cgbmv6qk1haj709hjx5q4sl7wgh91i459gzs1203adwc7rvk6jv";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ]; # needed for cross
  buildInputs = lib.optionals enableStatic [ stdenv.cc.libc stdenv.cc.libc.static ];

  postPatch = "patchShebangs .";

  inherit extraConfig;
  passAsFile = [ "extraConfig" ];

  configurePhase = ''
    make ${if enableMinimal then
      "allnoconfig"
    else
      if stdenv.isFreeBSD then
        "freebsd_defconfig"
      else
        if stdenv.isDarwin then
          "macos_defconfig"
        else
          "defconfig"
    }

    cat $extraConfigPath .config > .config-
    mv .config- .config

    make oldconfig
  '';

  makeFlags = [ "PREFIX=$(out)/bin" ] ++ lib.optional enableStatic "LDFLAGS=--static";

  installTargets = [ "install_flat" ];

  # tests currently (as of 0.8.0) get stuck in an infinite loop...
  # ...this is fixed in latest git, so doCheck can likely be enabled for next release
  # see https://github.com/landley/toybox/commit/b928ec480cd73fd83511c0f5ca786d1b9f3167c3
  #doCheck = true;
  checkInputs = [ which ]; # used for tests with checkFlags = [ "DEBUG=true" ];
  checkTarget = "tests";

  NIX_CFLAGS_COMPILE = "-Wno-error";

  meta = with stdenv.lib; {
    description = "Lightweight implementation of some Unix command line utilities";
    homepage = "https://landley.net/toybox/";
    license = licenses.bsd0;
    platforms = with platforms; linux ++ darwin ++ freebsd;
    # https://github.com/NixOS/nixpkgs/issues/101229
    broken = stdenv.isDarwin;
    maintainers = with maintainers; [ hhm ];
    priority = 10;
  };
}
