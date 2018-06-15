{ useLua ? !stdenv.isDarwin
, usePcre ? true
, stdenv, fetchurl, fetchpatch
, openssl, zlib, lua5_3 ? null, pcre ? null
}:

assert useLua -> lua5_3 != null;
assert usePcre -> pcre != null;

stdenv.mkDerivation rec {
  pname = "haproxy";
  version = "1.8.9";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://www.haproxy.org/download/${stdenv.lib.versions.majorMinor version}/src/${name}.tar.gz";
    sha256 = "00miblgwll3mycsgmp3gd3cn4lwsagxzgjxk5i6csnyqgj97fss3";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2018-11469.patch";
      url = "https://git.haproxy.org/?p=haproxy-1.8.git;a=patch;h=17514045e5d934dede62116216c1b016fe23dd06";
      sha256 = "0hzcvghg8qz45n3mrcgsjgvrvicvbvm52cc4hs5jbk1yb50qvls7";
    })
  ] ++ stdenv.lib.optional stdenv.isDarwin (fetchpatch {
    name = "fix-darwin-no-threads-build.patch";
    url = "https://git.haproxy.org/?p=haproxy-1.8.git;a=patch;h=fbf09c441a4e72c4a690bc7ef25d3374767fe5c5;hp=3157ef219c493f3b01192f1b809a086a5b119a1e";
    sha256 = "16ckzb160anf7xih7mmqy59pfz8sdywmyblxnr7lz9xix3jwk55r";
  });

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
  ] ++ stdenv.lib.optional stdenv.isDarwin "CC=cc";

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
    maintainers = with stdenv.lib.maintainers; [ fuzzy-id garbas ];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
    license = stdenv.lib.licenses.gpl2;
  };
}
