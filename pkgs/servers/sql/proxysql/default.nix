{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, autoconf
, automake
, bison
, cmake
, libtool
, civetweb
, coreutils
, curl
, flex
, gnutls
, jemalloc
, libconfig
, libdaemon
, libev
, libgcrypt
, libinjection
, libmicrohttpd_0_9_70
, lz4
, nlohmann_json
, openssl
, pcre
, perl
, prometheus-cpp
, python2
, re2
, zlib
}:

stdenv.mkDerivation rec {
  pname = "proxysql";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "sysown";
    repo = pname;
    rev = version;
    sha256 = "13l4bf7zhfjy701qx9hfr40vlsm4d0pbfmwr5d6lf514xznvsnzl";
  };

  patches = [
    ./makefiles.patch
    ./dont-phone-home.patch
    (fetchpatch {
      url = "https://github.com/sysown/proxysql/pull/3402.patch";
      sha256 = "079jjhvx32qxjczmsplkhzjn9gl7c2a3famssczmjv2ffs65vibi";
    })
  ];

  nativeBuildInputs = [
    autoconf
    automake
    cmake
    libtool
    perl
    python2
  ];

  buildInputs = [
    bison
    curl
    flex
    gnutls
    libgcrypt
    openssl
    zlib
  ];

  GIT_VERSION = version;

  dontConfigure = true;

  # replace and fix some vendored dependencies
  preBuild = /* sh */ ''
    pushd deps

    function replace_dep() {
      local folder="$1"
      local src="$2"
      local symlink="$3"
      local name="$4"

      pushd "$folder"

      rm -rf "$symlink"
      if [ -d "$src" ]; then
        cp -R "$src"/. "$symlink"
        chmod -R u+w "$symlink"
      else
        tar xf "$src"
        ln -s "$name" "$symlink"
      fi

      popd
    }

    ${lib.concatMapStringsSep "\n"
      (x: ''replace_dep "${x.f}" "${x.p.src}" "${x.p.pname or (builtins.parseDrvName x.p.name).name}" "${x.p.name}"'') [
        { f = "curl"; p = curl; }
        { f = "jemalloc"; p = jemalloc; }
        { f = "libconfig"; p = libconfig; }
        { f = "libdaemon"; p = libdaemon; }
        { f = "libev"; p = libev; }
        { f = "libinjection"; p = libinjection; }
        { f = "libmicrohttpd"; p = libmicrohttpd_0_9_70; }
        { f = "libssl"; p = openssl; }
        { f = "lz4"; p = lz4; }
        { f = "pcre"; p = pcre; }
        { f = "prometheus-cpp"; p = prometheus-cpp; }
        { f = "re2"; p = re2; }
    ]}

    pushd libhttpserver
    tar xf libhttpserver-0.18.1.tar.gz
    sed -i s_/bin/pwd_${coreutils}/bin/pwd_g libhttpserver/configure.ac
    popd

    pushd json
    rm json.hpp
    ln -s ${nlohmann_json.src}/single_include/nlohmann/json.hpp .
    popd

    pushd prometheus-cpp/prometheus-cpp/3rdparty
    replace_dep . "${civetweb.src}" civetweb
    popd

    sed -i s_/usr/bin/env_${coreutils}/bin/env_g libssl/openssl/config

    # https://github.com/sysown/proxysql/issues/3679
    # TODO: remove when upgrading past 2.3.2
    sed -i -e 's@^\(\s\+cd curl/curl \&\& ./configure .*\) \(--with-ssl=.*\)$@\1 --without-zstd \2@' Makefile

    popd
    patchShebangs .
  '';

  preInstall = ''
    mkdir -p $out/{etc,bin,lib/systemd/system}
  '';

  postInstall = ''
    sed -i s_/usr/bin/proxysql_$out/bin/proxysql_ $out/lib/systemd/system/*.service
  '';

  meta = with lib; {
    homepage = "https://proxysql.com/";
    broken = stdenv.isDarwin;
    description = "High-performance MySQL proxy";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ ajs124 ];
  };
}
