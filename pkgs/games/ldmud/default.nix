{ lib
, fetchFromGitHub
, stdenv
, autoreconfHook
, pkg-config
, bison
, libiconv
, pcre
, libgcrypt
, libxcrypt
, json_c
, libxml2
, ipv6Support ? false
, mccpSupport ? false
, zlib
, mysqlSupport ? false
, libmysqlclient
, postgresSupport ? false
, postgresql
, sqliteSupport ? false
, sqlite
, tlsSupport ? false
, openssl
, pythonSupport ? false
, python310
, ...
}:

stdenv.mkDerivation rec {
  pname = "ldmud";
  version = "3.6.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-PkrjP7tSZMaj61Hsn++7+CumhqFPLbf0+eAI6afP9HA=";
  };

  sourceRoot = "${src.name}/src";

  nativeBuildInputs =
    [ autoreconfHook pkg-config bison ];
  buildInputs = [ libgcrypt libxcrypt pcre json_c libxml2 ]
    ++ lib.optional mccpSupport zlib ++ lib.optional mysqlSupport libmysqlclient
    ++ lib.optional postgresSupport postgresql
    ++ lib.optional sqliteSupport sqlite ++ lib.optional tlsSupport openssl
    ++ lib.optional pythonSupport python310
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  # To support systems without autoconf LD puts its configure.ac in a non-default
  # location and uses a helper script. We skip that script and symlink the .ac
  # file to where the autoreconfHook find it.
  preAutoreconf = ''
    ln -fs ./autoconf/configure.ac ./
  '';

  configureFlags = [
    "--enable-erq=xerq"
    "--enable-filename-spaces"
    "--enable-use-json"
    "--enable-use-xml=xml2"
    (lib.enableFeature ipv6Support "use-ipv6")
    (lib.enableFeature mccpSupport "use-mccp")
    (lib.enableFeature mysqlSupport "use-mysql")
    (lib.enableFeature postgresSupport "use-pgsql")
    (lib.enableFeature sqliteSupport "use-sqlite")
    (lib.enableFeatureAs tlsSupport "use-tls" "ssl")
    (lib.enableFeature pythonSupport "use-python")
  ];

  preConfigure = lib.optionalString mysqlSupport ''
    export CPPFLAGS="-I${lib.getDev libmysqlclient}/include/mysql"
    export LDFLAGS="-L${libmysqlclient}/lib/mysql"
  '';

  installTargets = [ "install-driver" "install-utils" "install-headers" ];

  postInstall = ''
    mkdir -p "$out/share/"
    cp -v ../COPYRIGHT $out/share/
  '';

  meta = with lib; {
    description = "Gamedriver for LPMuds including a LPC compiler, interpreter and runtime";
    homepage = "https://ldmud.eu";
    changelog = "https://github.com/ldmud/ldmud/blob/${version}/HISTORY";
    longDescription = ''
      LDMud started as a project to clean up and modernize Amylaar's LPMud
      gamedriver. Primary goals are full documentation, a commented source body
      and out-of-the-box support for the major mudlibs, of which the commented
      source body has been pretty much completed. During the course of work
      a lot of bug fixes and improvements found their way into the driver - much
      more than originally expected, and definitely enough to make LDMud
      a driver in its own right.
    '';
    # See https://github.com/ldmud/ldmud/blob/master/COPYRIGHT
    license = licenses.unfreeRedistributable;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ cpu ];
  };
}
