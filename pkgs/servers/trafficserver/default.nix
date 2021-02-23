{ pcre, openssl, tcl, expat, perl, hwloc, unwind, libcurl, curses }:

stdenv.mkDerivation rec {
  version = "9.0.0";
  pname = "trafficserver";

  # not using fetchFromGitHub as the git repo relies on submodules that are included in the tar file
  src = fetchurl {
    url = "https://www.apache.org/dyn/closer.cgi/trafficserver/trafficserver-${version}.tar.bz2";
    sha256 = "sha256-1cffdff67711828df21d942ceff8acc798cdc50f5de1a7158edb5037fd4c6945";
  };

  nativeBuildInputs = [
    gcc
    make
    binutils
  ];

configureFlags = [
    "--with-experimental-plugins"
];

  enableParallelBuilding = true;

  stripDebugList = [ "lib" "modules" "bin" ];

  postInstall = ''
    make install
    mv $out /
  '';

  meta = with lib; {
    description = "Traffic Server";
    homepage = "https://trafficserver.apache.org";
    license = with licenses; [ asl20 gpl2Only ];
    maintainers = with maintainers; [
      joaquinito2051
    ];
    platforms = platforms.all;
  };
}
