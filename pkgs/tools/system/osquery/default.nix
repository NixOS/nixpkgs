{ stdenv, lib, fetchFromGitHub, pkgconfig, cmake, pythonPackages
, udev, audit, aws-sdk-cpp, cryptsetup, lvm2, libgcrypt, libarchive
, libgpgerror, libuuid, iptables, dpkg, lzma, bzip2, rpm
, beecrypt, augeas, libxml2, sleuthkit, yara, lldpd, google-gflags
, thrift, boost, rocksdb_lite, glog, gbenchmark, snappy
, openssl, file, doxygen
, gtest, sqlite, fpm, zstd, rdkafka, rapidjson
}:

let

  thirdparty = fetchFromGitHub {
    owner = "osquery";
    repo = "third-party";
    rev = "32e01462fbea75d3b1904693f937dfd62eaced15";
    sha256 = "0va24gmgk43a1lyjs63q9qrhvpv8gmqjzpjr5595vhr16idv8wyf";
  };

in

stdenv.mkDerivation rec {
  name = "osquery-${version}";
  version = "3.2.9";

  # this is what `osquery --help` will show as the version.
  OSQUERY_BUILD_VERSION = version;
  OSQUERY_PLATFORM = "NixOS;";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "osquery";
    rev = version;
    sha256 = "1fac0yj1701469qhbsp38ab2fmavm3jw6x278bf78yvxdi99ivai";
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
