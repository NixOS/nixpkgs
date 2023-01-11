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
, re2
, zlib
, texinfo
}:

stdenv.mkDerivation rec {
  pname = "proxysql";
  version = "2.4.5";

  src = fetchFromGitHub {
    owner = "sysown";
    repo = pname;
    rev = version;
    hash = "sha256-JWrll6VF0Ss1DlPNrh+xd3sGMclMeb6dlVgHd/UaNs0=";
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

  # otherwise, it looks for …-1.15
  ACLOCAL = "aclocal";
  AUTOMAKE = "automake";

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
          { f = "re2"; p = re2; }
        ]
      )}

    pushd libhttpserver
    tar xf libhttpserver-0.18.1.tar.gz
    sed -i s_/bin/pwd_${coreutils}/bin/pwd_g libhttpserver/configure.ac
    popd

    pushd json
    rm json.hpp
    ln -s ${nlohmann_json.src}/single_include/nlohmann/json.hpp .
    popd

    pushd prometheus-cpp
    tar xf v0.9.0.tar.gz
    replace_dep prometheus-cpp/3rdparty "${civetweb.src}" civetweb
    popd

    sed -i s_/usr/bin/env_${coreutils}/bin/env_g libssl/openssl/config

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
