{ stdenv, fetchurl, fetchFromGitHub, autoconf, automake, libtool, pcre
, withCrypto ? true, openssl
, enableMagic ? true, file
, enableCuckoo ? true, jansson
}:

stdenv.mkDerivation rec {
  version = "3.4.0";
  name = "yara-${version}";

  src = fetchFromGitHub {
    owner = "plusvic";
    repo = "yara";
    rev = "v${version}";
    sha256 = "1rv1xixbjqx1vkcij8r01rq08ncqgy6nn98xvkrpixwvi4fy956s";
  };

  # FIXME: this is probably not the right way to make it work
  # make[2]: *** No rule to make target 'libyara/.libs/libyara.a', needed by 'yara'.  Stop.
  dynamic_library_extension = ""
    + stdenv.lib.optionalString stdenv.isLinux "so"
    + stdenv.lib.optionalString stdenv.isDarwin "dylib"
  ;
  prePatch = ''
    cat >staticlibrary.patch <<EOF
    --- a/Makefile.am 2015-11-01 11:39:12.000000000 +0100
    +++ b/Makefile.am 2015-11-01 11:45:32.000000000 +0100
    @@ -12 +12 @@
    -yara_LDADD = libyara/.libs/libyara.a
    +yara_LDADD = libyara/.libs/libyara.${dynamic_library_extension}
    @@ -15 +15 @@
    -yarac_LDADD = libyara/.libs/libyara.a
    +yarac_LDADD = libyara/.libs/libyara.${dynamic_library_extension}
    EOF
  '';
  patches = [
    (fetchurl {
      url = "https://github.com/plusvic/yara/pull/261.diff";
      sha256 = "1fkxnk84ryvrjq7p225xvw9pn5gm2bjia2jz38fclwbsaxdi6p3b";
    })
    "staticlibrary.patch"
  ];

  buildInputs = [ autoconf automake libtool pcre]
    ++ stdenv.lib.optionals withCrypto [ openssl ]
    ++ stdenv.lib.optionals enableMagic [ file ]
    ++ stdenv.lib.optionals enableCuckoo [ jansson ]
  ;

  preConfigure = "./bootstrap.sh";

  configureFlags = ""
    + stdenv.lib.optionalString withCrypto "--with-crypto "
    + stdenv.lib.optionalString enableMagic "--enable-magic "
    + stdenv.lib.optionalString enableCuckoo "--enable-cuckoo "
  ;

  meta = with stdenv.lib; {
    description = "The pattern matching swiss knife for malware researchers";
    homepage    = http://plusvic.github.io/yara/;
    license     = licenses.asl20;
    platforms   = stdenv.lib.platforms.all;
  };
}
