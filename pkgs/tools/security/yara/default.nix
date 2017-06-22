{ stdenv, fetchFromGitHub, autoconf, automake, libtool, pcre
, withCrypto ? true, openssl
, enableMagic ? true, file
, enableCuckoo ? true, jansson
}:

stdenv.mkDerivation rec {
  version = "3.6.0";
  name = "yara-${version}";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "yara";
    rev = "v${version}";
    sha256 = "05nadqpvihdyxym11mn6n02rzv2ng8ga7j9l0g5gnjx366gcai42";
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
