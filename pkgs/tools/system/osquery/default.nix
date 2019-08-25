{ stdenv, lib, fetchFromGitHub, pkgconfig, cmake, python
, udev, audit, aws-sdk-cpp, cryptsetup, lvm2, libgcrypt, libarchive
, libgpgerror, libuuid, iptables, dpkg, lzma, bzip2, rpm
, beecrypt, augeas, libxml2, sleuthkit, yara, lldpd, gflags
, thrift, boost, rocksdb_lite, glog, gbenchmark, snappy
, openssl, file, doxygen
, gtest, fpm, zstd, rdkafka, rapidjson, fetchgit, fetchurl, libelfin
, smartmontools, which, git, cscope, ctags, ssdeep
}:

let
  overrides = {
    # use older `lvm2` source for osquery, the 2.03 sourcetree
    # will break osquery due to the lacking header `lvm2app.h`.
    #
    # https://github.com/NixOS/nixpkgs/pull/51756#issuecomment-446035295
    lvm2 = lvm2.overrideAttrs (old: rec {
      name = "lvm2-${version}";
      version = "2.02.183";
      src = fetchgit {
        url = "git://sourceware.org/git/lvm2.git";
        rev = "v${version}";
        sha256 = "1ny3srcsxd6kj59zq1cman5myj8kzw010wbyc6mrpk4kp823r5nx";
      };
    });

    # use smartmontools fork to programatically retrieve SMART information.
    # https://github.com/facebook/osquery/pull/4133
    smartmontools = smartmontools.overrideAttrs (old: rec {
      name = "smartmontools-${version}";
      version = "0.3.1";
      src = fetchFromGitHub {
        owner = "allanliu";
        repo = "smartmontools";
        rev = "v${version}";
        sha256 = "1i72fk2ranrky02h7nh9l3va4kjzj0lx1gr477zkxd44wf3w0pjf";
      };

      # Apple build fix doesn't apply here and isn't needed as we
      # only support `osquery` on Linux.
      patches = [];
    });

    # dpkg 1.19.2 dropped api in `<dpkg/dpkg-db.h>` which breaks compilation.
    dpkg = dpkg.overrideAttrs (old: rec {
      name = "dpkg-${version}";
      version = "1.19.0.5";
      src = fetchurl {
        url = "mirror://debian/pool/main/d/dpkg/dpkg_${version}.tar.xz";
        sha256 = "1dc5kp3fqy1k66fly6jfxkkg7w6d0jy8szddpfyc2xvzga94d041";
      };
    });

    # filter out static linking configuration to avoid that the library will
    # be linked both statically and dynamically.
    gflags = gflags.overrideAttrs (old: {
      cmakeFlags = stdenv.lib.filter (f: (builtins.match ".*STATIC.*" f) == null) old.cmakeFlags;
    });
  };
in

stdenv.mkDerivation rec {
  pname = "osquery";
  version = "3.3.2";

  # this is what `osquery --help` will show as the version.
  OSQUERY_BUILD_VERSION = version;
  OSQUERY_PLATFORM = "NixOS;";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = pname;
    rev = version;
    sha256 = "0nrwmzmbziacs3y0nljyc73bibr3w68myjpfwkicg9zgkq4qihij";
  };

  patches = [ ./0001-Fix-CMake-configuration-for-Nix.patch ];

  NIX_CFLAGS_COMPILE = [
    "-I${libxml2.dev}/include/libxml2"
  ];

  nativeBuildInputs = [ python which git cscope ctags cmake pkgconfig doxygen fpm ]
    ++ (with python.pkgs; [ jinja2 ]);

  buildInputs = [
    udev
    audit
    (aws-sdk-cpp.override {
      apis = [ "firehose" "kinesis" "sts" "ec2" ];
      customMemoryManagement = false;
    })
    overrides.lvm2
    libgcrypt
    libarchive
    libgpgerror
    libuuid
    iptables
    overrides.dpkg
    lzma
    bzip2
    rpm
    beecrypt
    augeas
    libxml2
    sleuthkit
    yara
    lldpd
    overrides.gflags
    thrift
    boost
    glog
    gbenchmark
    snappy
    openssl
    file
    cryptsetup
    gtest
    zstd
    rdkafka
    rapidjson
    rocksdb_lite
    libelfin
    ssdeep
    overrides.smartmontools
  ];

  cmakeFlags = [ "-DSKIP_TESTS=1" ];

  preConfigure = ''
    cp -r ${fetchFromGitHub {
      owner = "osquery";
      repo = "third-party";
      rev = "32e01462fbea75d3b1904693f937dfd62eaced15";
      sha256 = "0va24gmgk43a1lyjs63q9qrhvpv8gmqjzpjr5595vhr16idv8wyf";
    }}/* third-party

    chmod +w -R third-party
  '';

  meta = with lib; {
    description = "SQL powered operating system instrumentation, monitoring, and analytics";
    homepage = https://osquery.io/;
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ma27 ];
    broken = true;
  };
}
