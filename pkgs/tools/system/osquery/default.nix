{ stdenv, lib, fetchFromGitHub, pkgconfig, cmake, pythonPackages
, udev, audit, aws-sdk-cpp, cryptsetup, lvm2, libgcrypt, libarchive
, libgpgerror, libuuid, iptables, dpkg, lzma, bzip2, rpm
, beecrypt, augeas, libxml2, sleuthkit, yara, lldpd, google-gflags
, thrift, boost, rocksdb_lite, glog, gbenchmark, snappy
, openssl, file, doxygen
, gtest, sqlite, fpm, zstd, rdkafka, rapidjson, path
}:

let

  thirdparty = fetchFromGitHub {
    owner = "osquery";
    repo = "third-party";
    rev = "4ef099c31a1165c5e7e3a699f9e4b3eb68c3c3d9";
    sha256 = "1vm0prw4dix0m51vkw9z0vwfd8698gqjw499q8h604hs1rvn6132";
  };

in

stdenv.mkDerivation rec {
  name = "osquery-${version}";
  version = "3.2.2";

  # this is what `osquery --help` will show as the version.
  OSQUERY_BUILD_VERSION = version;
  OSQUERY_PLATFORM = "nixos;${builtins.readFile "${toString path}/.version"}";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "osquery";
    rev = version;
    sha256 = "0qwj4cy6m25sqwb0irqfqinipx50l4imnz1gqxx147vzfwb52jlq";
  };

  patches = [ ./misc.patch ];

  nativeBuildInputs = [
    pkgconfig cmake pythonPackages.python pythonPackages.jinja2 doxygen fpm
  ];

  buildInputs = let
    gflags' = google-gflags.overrideAttrs (old: {
      cmakeFlags = stdenv.lib.filter (f: isNull (builtins.match ".*STATIC.*" f)) old.cmakeFlags;
    });
  in [
    udev audit

    (aws-sdk-cpp.override {
      apis = [ "firehose" "kinesis" "sts" "ec2" ];
      customMemoryManagement = false;
    })

    lvm2 libgcrypt libarchive libgpgerror libuuid iptables dpkg
    lzma bzip2 rpm beecrypt augeas libxml2 sleuthkit
    yara lldpd gflags' thrift boost
    glog gbenchmark snappy openssl
    file cryptsetup
    gtest sqlite zstd rdkafka rapidjson rocksdb_lite
  ];

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="-I${libxml2.dev}/include/libxml2 $NIX_CFLAGS_COMPILE"

    cmakeFlagsArray+=(
      -DCMAKE_LIBRARY_PATH=${cryptsetup}/lib
      -DCMAKE_VERBOSE_MAKEFILE=OFF
    )

    cp -r ${thirdparty}/* third-party
    chmod +w -R third-party
    rm -r third-party/{googletest,sqlite3}
  '';

  meta = with lib; {
    description = "SQL powered operating system instrumentation, monitoring, and analytics";
    homepage = https://osquery.io/;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ma27 ];
  };
}
