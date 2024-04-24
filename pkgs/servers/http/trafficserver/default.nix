{ lib
, stdenv
, fetchzip
, makeWrapper
, nixosTests
, pkg-config
, file
, linuxHeaders
, openssl
, pcre
, perlPackages
, python3
, xz
, zlib
, catch2
# recommended dependencies
, withHwloc ? true
, hwloc
, withCurl ? true
, curl
, withCurses ? true
, ncurses
, withCap ? stdenv.isLinux
, libcap
, withUnwind ? stdenv.isLinux
, libunwind
# optional dependencies
, withBrotli ? false
, brotli
, withCjose ? false
, cjose
, withGeoIP ? false
, geoip
, withHiredis ? false
, hiredis
, withImageMagick ? false
, imagemagick
, withJansson ? false
, jansson
, withKyotoCabinet ? false
, kyotocabinet
, withLuaJIT ? false
, luajit
, withMaxmindDB ? false
, libmaxminddb
# optional features
, enableWCCP ? false
}:

stdenv.mkDerivation rec {
  pname = "trafficserver";
  version = "9.2.4";

  src = fetchzip {
    url = "mirror://apache/trafficserver/trafficserver-${version}.tar.bz2";
    hash = "sha256-oB3Wv4F6d0+lT1zIDUemgOJzwj+9Nz3uTklkXiWTBKg=";
  };

  # NOTE: The upstream README indicates that flex is needed for some features,
  # but it actually seems to be unnecessary as of this commit[1]. The detection
  # logic for bison and flex is still present in the build script[2], but no
  # other code seems to depend on it. This situation is susceptible to change
  # though, so it's a good idea to inspect the build scripts periodically.
  #
  # [1]: https://github.com/apache/trafficserver/pull/5617
  # [2]: https://github.com/apache/trafficserver/blob/3fd2c60/configure.ac#L742-L788
  nativeBuildInputs = [ makeWrapper pkg-config file python3 ]
    ++ (with perlPackages; [ perl ExtUtilsMakeMaker ])
    ++ lib.optionals stdenv.isLinux [ linuxHeaders ];

  buildInputs = [
    openssl
    pcre
    perlPackages.perl
  ] ++ lib.optional withBrotli brotli
  ++ lib.optional withCap libcap
  ++ lib.optional withCjose cjose
  ++ lib.optional withCurl curl
  ++ lib.optional withGeoIP geoip
  ++ lib.optional withHiredis hiredis
  ++ lib.optional withHwloc hwloc
  ++ lib.optional withImageMagick imagemagick
  ++ lib.optional withJansson jansson
  ++ lib.optional withKyotoCabinet kyotocabinet
  ++ lib.optional withCurses ncurses
  ++ lib.optional withLuaJIT luajit
  ++ lib.optional withUnwind libunwind
  ++ lib.optional withMaxmindDB libmaxminddb;

  outputs = [ "out" "man" ];

  postPatch = ''
    patchShebangs \
      iocore/aio/test_AIO.sample \
      src/traffic_via/test_traffic_via \
      src/traffic_logstats/tests \
      tools/check-unused-dependencies

    substituteInPlace configure --replace '/usr/bin/file' '${file}/bin/file'
  '' + lib.optionalString stdenv.isLinux ''
    substituteInPlace configure \
      --replace '/usr/include/linux' '${linuxHeaders}/include/linux'
  '' + lib.optionalString stdenv.isDarwin ''
    # 'xcrun leaks' probably requires non-free XCode
    substituteInPlace iocore/net/test_certlookup.cc \
      --replace 'xcrun leaks' 'true'
  '';

  configureFlags = [
    "--enable-layout=NixOS"
    "--enable-experimental-plugins"
    (lib.enableFeature enableWCCP "wccp")

    (lib.withFeatureAs withHiredis "hiredis" hiredis)
  ];

  installFlags = [
    "pkgsysconfdir=${placeholder "out"}/etc/trafficserver"

    # replace runtime directories with an install-time placeholder directory
    "pkgcachedir=${placeholder "out"}/.install-trafficserver"
    "pkglocalstatedir=${placeholder "out"}/.install-trafficserver"
    "pkglogdir=${placeholder "out"}/.install-trafficserver"
    "pkgruntimedir=${placeholder "out"}/.install-trafficserver"
  ];

  postInstall = ''
    substituteInPlace rc/trafficserver.service --replace "syslog.target" ""
    install -Dm644 rc/trafficserver.service $out/lib/systemd/system/trafficserver.service

    wrapProgram $out/bin/tspush \
      --set PERL5LIB '${with perlPackages; makePerlPath [ URI ]}' \
      --prefix PATH : "${lib.makeBinPath [ file ]}"

    find "$out" -name '*.la' -delete

    # ensure no files actually exist in this directory
    rmdir $out/.install-trafficserver
  '';

  installCheckPhase = let
    expected = ''
      Via header is [uScMsEf p eC:t cCMp sF], Length is 22
      Via Header Details:
      Request headers received from client                   :simple request (not conditional)
      Result of Traffic Server cache lookup for URL          :miss (a cache "MISS")
      Response information received from origin server       :error in response
      Result of document write-to-cache:                     :no cache write performed
      Proxy operation result                                 :unknown
      Error codes (if any)                                   :connection to server failed
      Tunnel info                                            :no tunneling
      Cache Type                                             :cache
      Cache Lookup Result                                    :cache miss (url not in cache)
      Parent proxy connection status                         :no parent proxy or unknown
      Origin server connection status                        :connection open failed
    '';
  in ''
    runHook preInstallCheck
    diff -Naur <($out/bin/traffic_via '[uScMsEf p eC:t cCMp sF]') - <<EOF
    ${lib.removeSuffix "\n" expected}
    EOF
    runHook postInstallCheck
  '';

  doCheck = true;
  doInstallCheck = true;
  enableParallelBuilding = true;

  passthru.tests = { inherit (nixosTests) trafficserver; };

  meta = with lib; {
    homepage = "https://trafficserver.apache.org";
    changelog = "https://raw.githubusercontent.com/apache/trafficserver/${version}/CHANGELOG-${version}";
    description = "Fast, scalable, and extensible HTTP caching proxy server";
    longDescription = ''
      Apache Traffic Server is a high-performance web proxy cache that improves
      network efficiency and performance by caching frequently-accessed
      information at the edge of the network. This brings content physically
      closer to end users, while enabling faster delivery and reduced bandwidth
      use. Traffic Server is designed to improve content delivery for
      enterprises, Internet service providers (ISPs), backbone providers, and
      large intranets by maximizing existing and available bandwidth.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ midchildan ];
    platforms = platforms.unix;
  };
}
