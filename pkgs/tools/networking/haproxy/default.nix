{ useLua ? !stdenv.isDarwin
, usePcre ? true
, stdenv, fetchurl, fetchpatch
, openssl, zlib, lua5_3 ? null, pcre ? null
}:

assert useLua -> lua5_3 != null;
assert usePcre -> pcre != null;

stdenv.mkDerivation rec {
  pname = "haproxy";
  version = "1.9.8";

  src = fetchurl {
    url = "https://www.haproxy.org/download/${stdenv.lib.versions.majorMinor version}/src/${pname}-${version}.tar.gz";
    sha256 = "1via9k84ycrdr8qh4qchcbqgpv0gynm3ra23nwsvqwfqvc0376id";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2019-19330-part1.patch";
      url = "https://git.haproxy.org/?p=haproxy.git;a=patch;h=8f3ce06f14e13719c9353794d60001eab8d43717";
      sha256 = "14hzbv5hdxffiwxwdka1d50w2lpv9jhazrrg729nwbpz7hy2cn6c";
    })
    ./1.9.8-CVE-2019-19330-part2.patch
    (fetchpatch {
      name = "CVE-2019-19330-part3.patch";
      url = "https://git.haproxy.org/?p=haproxy.git;a=patch;h=146f53ae7e97dbfe496d0445c2802dd0a30b0878";
      sha256 = "1dv53l3yq9b3iym5x3985sb2lg0mwjyvn8ylkr6rwj0nm9bnshln";
    })
  ];

  buildInputs = [ openssl zlib ]
    ++ stdenv.lib.optional useLua lua5_3
    ++ stdenv.lib.optional usePcre pcre;

  # TODO: make it work on bsd as well
  makeFlags = [
    "PREFIX=\${out}"
    ("TARGET=" + (if stdenv.isSunOS  then "solaris"
             else if stdenv.isLinux  then "linux2628"
             else if stdenv.isDarwin then "osx"
             else "generic"))
  ];
  buildFlags = [
    "USE_OPENSSL=yes"
    "USE_ZLIB=yes"
  ] ++ stdenv.lib.optionals usePcre [
    "USE_PCRE=yes"
    "USE_PCRE_JIT=yes"
  ] ++ stdenv.lib.optionals useLua [
    "USE_LUA=yes"
    "LUA_LIB=${lua5_3}/lib"
    "LUA_INC=${lua5_3}/include"
  ] ++ stdenv.lib.optional stdenv.isDarwin "CC=cc"
    ++ stdenv.lib.optional stdenv.isLinux "USE_GETADDRINFO=1";

  meta = {
    description = "Reliable, high performance TCP/HTTP load balancer";
    longDescription = ''
      HAProxy is a free, very fast and reliable solution offering high
      availability, load balancing, and proxying for TCP and HTTP-based
      applications. It is particularly suited for web sites crawling under very
      high loads while needing persistence or Layer7 processing. Supporting
      tens of thousands of connections is clearly realistic with todays
      hardware.
    '';
    homepage = http://haproxy.1wt.eu;
    maintainers = with stdenv.lib.maintainers; [ fuzzy-id ];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
    license = stdenv.lib.licenses.gpl2;
  };
}
