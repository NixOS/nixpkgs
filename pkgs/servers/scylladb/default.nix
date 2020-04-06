{
  stdenv,
  fetchgit,
  python3Packages,
  pkgconfig,
  gcc8Stdenv,
  boost,
  git,
  systemd,
  gnutls,
  cmake,
  makeWrapper,
  ninja,
  ragel,
  hwloc,
  jsoncpp,
  antlr3,
  numactl,
  protobuf,
  cryptopp,
  libxfs,
  libyamlcpp,
  libsystemtap,
  lksctp-tools,
  lz4,
  libxml2,
  zlib,
  libpciaccess,
  snappy,
  libtool,
  thrift
}:
gcc8Stdenv.mkDerivation {
  pname = "scylladb";
  version = "3.0.5";

  src = fetchgit {
    url = "https://github.com/scylladb/scylla.git";
    rev = "403f66ecad6bc773712c69c4a80ebd172eb48b13";
    sha256 = "14mg0kzpkrxvwqyiy19ndy4rsc7s5gnv2gwd3xdwm1lx1ln8ywsi";
    fetchSubmodules = true;
  };

  patches = [ ./seastar-configure-script-paths.patch ./configure-etc-osrelease.patch ];

  nativeBuildInputs = [
   pkgconfig
   cmake
   makeWrapper
   ninja
  ];

  buildInputs = [
   antlr3
   python3Packages.pyparsing
   boost
   git
   systemd
   gnutls
   ragel
   jsoncpp
   numactl
   protobuf
   cryptopp
   libxfs
   libyamlcpp
   libsystemtap
   lksctp-tools
   lz4
   libxml2
   zlib
   libpciaccess
   snappy
   libtool
   thrift
  ];

  postPatch = ''
    patchShebangs ./configure.py
    patchShebangs seastar/json/json2code.py
  '';

  configurePhase = ''
    ./configure.py --mode=release
  '';

  installPhase = ''
    mkdir $out
    cp -r * $out/
  '';

  requiredSystemFeatures = [ "big-parallel" ];

  meta = with stdenv.lib; {
    description = "NoSQL data store using the seastar framework, compatible with Apache Cassandra";
    homepage = "https://scylladb.com";
    license = licenses.agpl3;
    platforms = stdenv.lib.platforms.linux;
    hydraPlatforms = []; # It's huge ATM, about 18 GB.
    maintainers = [ stdenv.lib.maintainers.farlion ];
  };
}
