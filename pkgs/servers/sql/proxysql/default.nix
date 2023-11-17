{ stdenv
, lib
, applyPatches
, fetchFromGitHub
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
, libconfig
, libdaemon
, libev
, libgcrypt
, libinjection
, libmicrohttpd_0_9_69
, libuuid
, lz4
, nlohmann_json
, openssl
, pcre
, perl
, python3
, prometheus-cpp
, zlib
, texinfo
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "proxysql";
  version = "2.5.5";

  src = fetchFromGitHub {
    owner = "sysown";
    repo = "proxysql";
    rev = finalAttrs.version;
    hash = "sha256-+3cOEM5b5HBQhuI+92meupvQnrUj8jgbedzPJqMoXc8=";
  };

  patches = [
    ./makefiles.patch
    ./dont-phone-home.patch
  ];

  nativeBuildInputs = [
    autoconf
    automake
    cmake
    libtool
    perl
    python3
    texinfo  # for makeinfo
  ];

  buildInputs = [
    bison
    curl
    flex
    gnutls
    libgcrypt
    libuuid
    zlib
  ];

  enableParallelBuilding = true;

  GIT_VERSION = finalAttrs.version;

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
      (x: ''replace_dep "${x.f}" "${x.p.src}" "${x.p.pname or (builtins.parseDrvName x.p.name).name}" "${x.p.name}"'') (
        map (x: {
          inherit (x) f;
          p = x.p // {
            src = applyPatches {
              inherit (x.p) src patches;
            };
          };
        }) [
          { f = "curl"; p = curl; }
          { f = "libconfig"; p = libconfig; }
          { f = "libdaemon"; p = libdaemon; }
          { f = "libev"; p = libev; }
          { f = "libinjection"; p = libinjection; }
          { f = "libmicrohttpd"; p = libmicrohttpd_0_9_69; }
          { f = "libssl"; p = openssl; }
          { f = "lz4"; p = lz4; }
          { f = "pcre"; p = pcre; }
          { f = "prometheus-cpp"; p = prometheus-cpp; }
        ]
      )}

    pushd libhttpserver
    tar xf libhttpserver-*.tar.gz
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

    pushd libmicrohttpd/libmicrohttpd
    autoreconf
    popd

    pushd libconfig/libconfig
    autoreconf
    popd

    pushd libdaemon/libdaemon
    autoreconf
    popd

    pushd pcre/pcre
    autoreconf
    popd

    popd
    patchShebangs .
  '';

  preInstall = ''
    mkdir -p $out/{etc,bin,lib/systemd/system}
  '';

  postInstall = ''
    sed -i s_/usr/bin/proxysql_$out/bin/proxysql_ $out/lib/systemd/system/*.service
  '';

  meta = {
    broken = stdenv.isDarwin;
    description = "High-performance MySQL proxy";
    homepage = "https://proxysql.com/";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ ajs124 ];
    platforms = lib.platforms.unix;
  };
})
