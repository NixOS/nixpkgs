{ lib, stdenv, fetchgit, fetchurl, git, cmake, pkg-config
, openssl, boost, grpc, protobuf, libnsl }:

let
  sqlite3 = fetchurl rec {
    url = "https://www.sqlite.org/2018/sqlite-amalgamation-3260000.zip";
    sha256 = "0vh9aa5dyvdwsyd8yp88ss300mv2c2m40z79z569lcxa6fqwlpfy";
    passthru.url = url;
  };

  boostSharedStatic = boost.override {
    enableShared = true;
    enabledStatic = true;
  };

  beast = fetchgit {
    url = "https://github.com/boostorg/beast.git";
    rev = "2f9a8440c2432d8a196571d6300404cb76314125";
    sha256 = "1n9ms5cn67b0p0mhldz5psgylds22sm5x22q7knrsf20856vlk5a";
    fetchSubmodules = false;
    leaveDotGit = true;
  };

  docca = fetchgit {
    url = "https://github.com/vinniefalco/docca.git";
    rev = "335dbf9c3613e997ed56d540cc8c5ff2e28cab2d";
    sha256 = "09cb90k0ygmnlpidybv6nzf6is51i80lnwlvad6ijc3gf1z6i1yh";
    fetchSubmodules = false;
    leaveDotGit = true;
  };

  nudb = fetchgit rec {
    url = "https://github.com/CPPAlliance/NuDB.git";
    rev = "2.0.5";
    sha256 = "07dwvglhyzpqnhzd33a2vs80wrdxy55a3sirnd739xp1k5v8s2fx";
    leaveDotGit = true;
    fetchSubmodules = true;
    postFetch = "cd $out && git tag ${rev}";
  };

  rocksdb = fetchgit rec {
    url = "https://github.com/facebook/rocksdb.git";
    rev = "v6.7.3";
    sha256 = "0dzn5jg3i2mnnjj24dn9lzi3aajj5ga2akjf64lybyj481lq445k";
    deepClone = true;
    fetchSubmodules = false;
    leaveDotGit = true;
  };

  lz4 = fetchgit rec {
    url = "https://github.com/lz4/lz4.git";
    rev = "v1.9.2";
    sha256 = "0322xy2vfhxkb8akas7vwajjgcigq1q8l9f5fnfmavcsd6kmxmgg";
    leaveDotGit = true;
    fetchSubmodules = false;
    postFetch = "cd $out && git tag ${rev}";
  };

  libarchive = fetchgit rec {
    url = "https://github.com/libarchive/libarchive.git";
    rev = "v3.4.3";
    sha256 = "00yrzy2129vr4nfhigd91651984sl447dyfjfz26dmzvna5hwzp1";
    leaveDotGit = true;
    fetchSubmodules = false;
    postFetch = "cd $out && git tag ${rev}";
  };

  soci = fetchgit {
    url = "https://github.com/SOCI/soci.git";
    rev = "04e1870294918d20761736743bb6136314c42dd5";
    sha256 = "0w3b7qi3bwn8bxh4qbqy6c1fw2bbwh7pxvk8b3qb6h4qgsh6kx89";
    leaveDotGit = true;
    fetchSubmodules = false;
  };

  snappy = fetchgit rec {
    url = "https://github.com/google/snappy.git";
    rev = "1.1.7";
    sha256 = "1f0i0sz5gc8aqd594zn3py6j4w86gi1xry6qaz2vzyl4w7cb4v35";
    leaveDotGit = true;
    fetchSubmodules = false;
    postFetch = "cd $out && git tag ${rev}";
  };

  cares = fetchgit rec {
    url = "https://github.com/c-ares/c-ares.git";
    rev = "cares-1_15_0";
    sha256 = "1fkzsyhfk5p5hr4dx4r36pg9xzs0md6cyj1q2dni3cjgqj3s518v";
    leaveDotGit = true;
    fetchSubmodules = false;
    postFetch = "cd $out && git tag ${rev}";
  };

  google-test = fetchgit {
    url = "https://github.com/google/googletest.git";
    rev = "5ec7f0c4a113e2f18ac2c6cc7df51ad6afc24081";
    sha256 = "1ch7hq16z20ddhpc08slp9bny29j88x9vr6bi9r4yf5m77xbplja";
    leaveDotGit = true;
    fetchSubmodules = false;
  };

  google-benchmark = fetchgit {
    url = "https://github.com/google/benchmark.git";
    rev = "5b7683f49e1e9223cf9927b24f6fd3d6bd82e3f8";
    sha256 = "0kcmb83framkncc50h0lyyz7v8nys6g19ja0h2p8x4sfafnnm6ig";
    leaveDotGit = true;
    fetchSubmodules = false;
  };

  date = fetchgit {
    url = "https://github.com/HowardHinnant/date.git";
    rev = "fc4cf092f9674f2670fb9177edcdee870399b829";
    sha256 = "0w618p64mx2l074b6wd0xfc4h6312mabhvzabxxwsnzj4afpajcm";
    leaveDotGit = true;
    fetchSubmodules = false;
  };
in stdenv.mkDerivation rec {
  pname = "rippled";
  version = "1.7.3";

  src = fetchgit {
    url = "https://github.com/ripple/rippled.git";
    rev = version;
    sha256 = "008qzb138r2pi0cqj4d6d5f0grlb2gm87m8j0dj8b0giya22xv6s";
    leaveDotGit = true;
    fetchSubmodules = true;
  };

  hardeningDisable = ["format"];
  cmakeFlags = ["-Dstatic=OFF" "-DBoost_NO_BOOST_CMAKE=ON"];

  nativeBuildInputs = [ pkg-config cmake git ];
  buildInputs = [ openssl openssl.dev boostSharedStatic grpc protobuf libnsl ];

  preConfigure = ''
    export HOME=$PWD

    git config --global url."file://${rocksdb}".insteadOf "${rocksdb.url}"
    git config --global url."file://${docca}".insteadOf "${docca.url}"
    git config --global url."file://${lz4}".insteadOf "${lz4.url}"
    git config --global url."file://${libarchive}".insteadOf "${libarchive.url}"
    git config --global url."file://${soci}".insteadOf "${soci.url}"
    git config --global url."file://${snappy}".insteadOf "${snappy.url}"
    git config --global url."file://${nudb}".insteadOf "${nudb.url}"
    git config --global url."file://${google-benchmark}".insteadOf "${google-benchmark.url}"
    git config --global url."file://${google-test}".insteadOf "${google-test.url}"
    git config --global url."file://${date}".insteadOf "${date.url}"

    substituteInPlace Builds/CMake/deps/Sqlite.cmake --replace "http://www.sqlite.org/2018/sqlite-amalgamation-3260000.zip" ""
    substituteInPlace Builds/CMake/deps/Sqlite.cmake --replace "https://www2.sqlite.org/2018/sqlite-amalgamation-3260000.zip" ""
    substituteInPlace Builds/CMake/deps/Sqlite.cmake --replace "http://www2.sqlite.org/2018/sqlite-amalgamation-3260000.zip" ""
    substituteInPlace Builds/CMake/deps/Sqlite.cmake --replace "URL ${sqlite3.url}" "URL ${sqlite3}"
  '';

  doCheck = true;
  checkPhase = ''
    ./rippled --unittest
  '';

  meta = with lib; {
    description = "Ripple P2P payment network reference server";
    homepage = "https://github.com/ripple/rippled";
    maintainers = with maintainers; [ offline RaghavSood ];
    license = licenses.isc;
    platforms = [ "x86_64-linux" ];
  };
}
