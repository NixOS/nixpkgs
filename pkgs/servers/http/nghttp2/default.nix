{ stdenv, fetchurl, pkgconfig, cunit, tzdata
, openssl , libev, zlib, c-ares, libxml2, jansson, jemalloc, systemd ? null
}:

let
  inherit (stdenv.lib) optional;
in

stdenv.mkDerivation rec {
  name = "nghttp2-${version}";
  version = "1.28.0";

  src = fetchurl {
    url = "https://github.com/nghttp2/nghttp2/releases/download/v${version}/nghttp2-${version}.tar.xz";
    sha256 = "13gxk72manbmaaf3mahvihfw71zas1m7z8j2bs9s7v2dc403yv0d";
  };

  # https://nghttp2.org/documentation/package_README.html#requirements
  nativeBuildInputs = [ pkgconfig cunit ];
  buildInputs = [ openssl libev zlib c-ares libxml2 jansson jemalloc ]
    ++ optional stdenv.isLinux systemd.dev;  # for systemd support in nghttpx

  configureFlags = [
    "--enable-app"  # automatic but better be explicit
    "--with-jemalloc"
    "--enable-hpack-tools"
    "--disable-examples"
    "--disable-python-bindings"
  ];

  enableParallelBuilding = true;

  doCheck = true; # needs TZDIR to be set otherwise test util_localtime_date will fail
  preCheck = ''
    export TZDIR=${tzdata}/share/zoneinfo
  '';

  postInstall = ''
    install -Dm555 contrib/tlsticketupdate.go $out/share/nghttp2/
    install -Dm444 contrib/nghttpx.service $out/share/nghttp2/
    install -Dm444 nghttpx.conf.sample $out/share/nghttp2/
  '';

  meta = with stdenv.lib; {
    homepage = https://nghttp2.org/;
    description = "A C implementation of the HyperText Transfer Protocol version 2";
    longDescription = ''
      nghttp2 provides the following tools:
      * nghttp: an HTTP/2 client
      * nghttpd: an HTTP/2 server
      * nghttpx: a reverse or forward proxy for HTTP/2 and HTTP/1
      * h2load: a benchmarking tool for HTTP/2 and SPDY server
      * deflatehd and inflatehd : command-line HPACK headers compression and decompression tools

      NOTE: the C library and its development files are available in the "libnghttp2" package.
    '';
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ c0bw3b wkennington ];
  };
}
