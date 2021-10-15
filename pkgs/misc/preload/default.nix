{
  lib,
  stdenv,
  fetchurl,
  glib,
  pkg-config,
  help2man,
  autoreconfHook,
}:
stdenv.mkDerivation rec {
  pname = "preload";
  version = "0.6.4";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "d0a558e83cb29a51d9d96736ef39f4b4e55e43a589ad1aec594a048ca22f816b";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    help2man
  ];

  buildInputs = [
    glib
  ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
  ];

  installFlags = [
    "sbindir=$(out)/bin"
    "sysconfdir=./discard" # configuration done using nixos module
    "localstatedir=./discard" # discard the files and dirs, they're created in the module
  ];

  postPatch = ''
    # "--logdir=/var/log/preload" failed with unknown option
    substituteInPlace configure.ac \
      --replace "logdir='\''${localstatedir}/log'" "logdir='\''${localstatedir}/log/preload'"
  '';

  # loops '0kb available for preloading, using 0kb of it'
  doCheck = false;

  meta = with lib; {
    homepage = "http://sourceforge.net/projects/preload";
    description = "Makes applications run faster by prefetching binaries and shared objects";
    license = licenses.gpl1;
    platforms = platforms.linux;
  };
}
