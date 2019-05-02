{
  stdenv, lib, fetchFromGitHub, which,
  enableStatic ? false,
  enableMinimal ? false,
  extraConfig ? ""
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "toybox";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "landley";
    repo = pname;
    rev = version;
    sha256 = "00q6vlc06xbhcjcyqkyp66d1pv7qgwhs00gk4vyixhjqh80giwzl";
  };

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

  installTargets = "install_flat";

  # tests currently (as of 0.8.0) get stuck in an infinite loop...
  # ...this is fixed in latest git, so doCheck can likely be enabled for next release
  # see https://github.com/landley/toybox/commit/b928ec480cd73fd83511c0f5ca786d1b9f3167c3
  #doCheck = true;
  checkInputs = [ which ]; # used for tests with checkFlags = [ "DEBUG=true" ];
  checkTarget = "tests";

  NIX_CFLAGS_COMPILE = "-Wno-error";

  meta = with stdenv.lib; {
    description = "Lightweight implementation of some Unix command line utilities";
    homepage = https://landley.net/toybox/;
    license = licenses.bsd0;
    platforms = with platforms; linux ++ darwin ++ freebsd;
    maintainers = with maintainers; [ hhm ];
    priority = 10;
  };
}
