{ stdenv, fetchFromGitHub, autoconf, automake, libtool, pcre
, withCrypto ? true, openssl
, enableMagic ? true, file
, enableCuckoo ? true, jansson
}:

stdenv.mkDerivation rec {
  version = "3.7.1";
  name = "yara-${version}";

  src = fetchFromGitHub {
    owner = "VirusTotal";
    repo = "yara";
    rev = "v${version}";
    sha256 = "05smkn4ii8irx6ccnzrhwa39pkmrjyxjmfrwh6mhdd8iz51v5cgz";
  };

  # FIXME: this is probably not the right way to make it work
  # make[2]: *** No rule to make target 'libyara/.libs/libyara.a', needed by 'yara'.  Stop.
  prePatch = ''
    cat >staticlibrary.patch <<EOF
    --- a/Makefile.am 2015-11-01 11:39:12.000000000 +0100
    +++ b/Makefile.am 2015-11-01 11:45:32.000000000 +0100
    @@ -12 +12 @@
    -yara_LDADD = libyara/.libs/libyara.a
    +yara_LDADD = libyara/.libs/libyara${stdenv.hostPlatform.extensions.sharedLibrary}
    @@ -15 +15 @@
    -yarac_LDADD = libyara/.libs/libyara.a
    +yarac_LDADD = libyara/.libs/libyara${stdenv.hostPlatform.extensions.sharedLibrary}
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

  configureFlags = [
    (stdenv.lib.withFeature withCrypto "crypto")
    (stdenv.lib.enableFeature enableMagic "magic")
    (stdenv.lib.enableFeature enableCuckoo "cuckoo")
  ];

  meta = with stdenv.lib; {
    description = "The pattern matching swiss knife for malware researchers";
    homepage    = http://Virustotal.github.io/yara/;
    license     = licenses.asl20;
    platforms   = stdenv.lib.platforms.all;
  };
}
