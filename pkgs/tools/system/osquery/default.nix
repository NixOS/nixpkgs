{ stdenv, lib, fetchFromGitHub, pkgconfig, cmake, pythonPackages
, udev, audit, aws-sdk-cpp, cryptsetup, lvm2, libgcrypt, libarchive
, libgpgerror, libuuid, iptables, apt, dpkg, lzma, lz4, bzip2, rpm
, beecrypt, augeas, libxml2, sleuthkit, yara, lldpd, google-gflags
, thrift, boost, rocksdb_lite, cpp-netlib, glog, gbenchmark, snappy
, openssl, linenoise-ng, file, doxygen, devicemapper
}:

let
  thirdparty = fetchFromGitHub {
    owner = "osquery";
    repo = "third-party";
    rev = "6919841175b2c9cb2dee8986e0cfe49191ecb868";
    sha256 = "1kjxrky586jd1b2z1vs9cm7x1dxw51cizpys9kddiarapc2ih65j";
  };

in

stdenv.mkDerivation rec {
  name = "osquery-${version}";
  version = "2.5.2";

  # this is what `osquery --help` will show as the version.
  OSQUERY_BUILD_VERSION = version;

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "osquery";
    rev = version;
    sha256 = "16isplk66qpvhrf041l0lxb4z6k7wwd1sg7kpsw2q6kivkxpnk3z";
  };

  patches = [ ./misc.patch ] ++ lib.optional stdenv.isLinux ./platform-nixos.patch;

  nativeBuildInputs = [
    pkgconfig cmake pythonPackages.python pythonPackages.jinja2
  ];

  buildInputs = [
    udev audit

    (aws-sdk-cpp.override {
      apis = [ "firehose" "kinesis" "sts" ];
      customMemoryManagement = false;
    })

    lvm2 libgcrypt libarchive libgpgerror libuuid iptables.dev apt dpkg
    lzma lz4 bzip2 rpm beecrypt augeas libxml2 sleuthkit
    yara lldpd google-gflags thrift boost
    cpp-netlib glog gbenchmark snappy openssl linenoise-ng
    file doxygen devicemapper cryptsetup

    # need to be consistent about the malloc implementation
    (rocksdb_lite.override { jemalloc = null; gperftools = null; })
  ];

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="-I${libxml2.dev}/include/libxml2 $NIX_CFLAGS_COMPILE"

    cmakeFlagsArray+=(
      -DCMAKE_LIBRARY_PATH=${cryptsetup}/lib
      -DCMAKE_VERBOSE_MAKEFILE=ON
    )

    cp -r ${thirdparty}/* third-party
    chmod +w -R third-party
  '';

  meta = with lib; {
    description = "SQL powered operating system instrumentation, monitoring, and analytics";
    homepage = "https://osquery.io/";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
