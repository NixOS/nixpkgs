{stdenv, fetchurl, zlibSupport ? false, zlib, sslSupport ? false, openssl ? null}:

assert zlibSupport -> zlib != null;
assert sslSupport -> openssl != null;

stdenv.mkDerivation ({
  name = "curl-7.15.5";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/curl-7.15.5.tar.bz2;
    md5 = "594142c7d53bbdd988e8cef6354eeeff";
  };
  buildInputs =
    (if zlibSupport then [zlib] else [])
    ++ (if sslSupport then [openssl] else []);
  patches = [./configure-cxxcpp.patch];
  configureFlags = "
    ${if sslSupport then "--with-ssl=${openssl}" else "--without-ssl"}
  ";
  inherit sslSupport openssl;
}

// (if stdenv ? isDietLibC then {
  CFLAGS = "-DHAVE_INET_NTOA_R_2_ARGS=1";
} else {})

)
