{ stdenv, fetchurl, fetchzip, fetchFromGitHub, perl
, openssl
, expat
, mysql
, gd
, unzip
, pkgconfig
, gmp
, pari
}:

let
  bmoRev = "78eac2241f5b7e701b2c7b62a0ec0b8272495cca";
  pariSrc = fetchurl {
    url = "http://s3.amazonaws.com/moz-devservices-bmocartons/third-party/pari-2.1.7.tgz";
    sha256 = "1yjml5z1qdn258qh6329v7vib2gyx6q2np0s5ybci0rhmz6z4hli";
  };
in stdenv.mkDerivation {
  name = "bugzilla-XXX";
  srcs = [
    (fetchurl {
      url = "https://moz-devservices-bmocartons.s3.amazonaws.com/bmo22/vendor.tar.gz";
      sha256 = "0aqh9wmz6kbab0iwccp9fwfrkd28gcq3f284hhxaa36d28rz11x4";
    })
    (fetchFromGitHub {
      owner = "mozilla-bteam";
      repo = "bmo";
      rev = bmoRev;
      sha256 = "1hh20p1wmqgkyx95dhgi3bh1nfjfc7d802i2238g6rczg76lxjab";
    })
  ];
  buildInputs = [
    perl
    unzip
    pkgconfig
    openssl
    openssl.dev
    expat
    expat.dev
    mysql
    gd
    gd.dev
    gmp
    gmp.dev
    pari
  ];
  sourceRoot = ".";
  buildPhase = ''
    export PERL_CPANM_HOME=`pwd`/.cpanm;

    mkdir -p tmp;
    cp -R bmo-${bmoRev}-src/* tmp/;
    cp -R bmo22/cpanfile* tmp/;
    cp -R bmo22/vendor tmp/;

    mkdir -p $PERL_CPANM_HOME/work;
    cp ${pariSrc} $PERL_CPANM_HOME/work/pari-2.1.7.tgz;

    mkdir openssl;
    ln -s ${openssl.out}/lib openssl;
    ln -s ${openssl.bin}/bin openssl;
    ln -s ${openssl.dev}/include openssl;
    export OPENSSL_PREFIX=$(realpath openssl);
    export EXPATLIBPATH=${expat.out}/lib;
    export EXPATINCPATH=${expat.dev}/include;

    pushd tmp;
    perl vendor/bin/carton install --deployment --cached;
    PERL5LIB="$PERL5LIB:$PWD/local/lib/perl5" perl -MXML::SAX -e "XML::SAX->add_parser(q(XML::SAX::PurePerl))->save_parsers()"
    popd;
  '';

  installPhase = ''
   mkdir $out
   cp -R tmp/local/* $out/
  '';

}
