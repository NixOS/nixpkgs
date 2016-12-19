{ stdenv, lib, fetchFromGitHub, openssl, zlib, libpcap, boost, cairo, automake, autoconf, useCairo ? false }:

stdenv.mkDerivation rec {
  baseName = "tcpflow";
  version  = "1.4.6";
  name     = "${baseName}-${version}";

  src = fetchFromGitHub {
    owner  = "simsong";
    repo   = "tcpflow";
    rev    = "017687365b8233d16260f4afd7572c8ad8873cf6";
    sha256 = "002cqmn786sjysf59xnbb7lgr23nqqslb2gvy29q2xpnq6my9w38";
  };

  be13_api = fetchFromGitHub {
    owner  = "simsong";
    repo   = "be13_api";
    rev    = "8f4f4b3fe0b4815babb3a6fb595eb9a6d07e8a2e";
    sha256 = "1dlys702x3m8cr9kf4b9j8n28yh6knhwgqkm6a5yhh1grd8r3ksm";
  };

  dfxml = fetchFromGitHub {
    owner  = "simsong";
    repo   = "dfxml";
    rev    = "13a8cc22189a8336d16777f2897ada6ae2ee59de";
    sha256 = "0wzhbkp4c8sp6wrk4ilz3skxp14scdnm3mw2xmxxrsifymzs2f5n";
  };

  httpparser = fetchFromGitHub {
    owner  = "nodejs";
    repo   = "http-parser";
    rev    = "8d9e5db981b623fffc93657abacdc80270cbee58";
    sha256 = "0x17wwhrc7b2ngiqy0clnzn1zz2gbcz5n9m29pcyrcplly782k52";
  };

  buildInputs = [ openssl zlib libpcap boost automake autoconf ] ++ lib.optional useCairo cairo;

  postUnpack = ''
    pushd tcpflow-*-src/src
    cp -rv ${be13_api}/* be13_api/
    cp -rv ${dfxml}/* dfxml/
    cp -rv ${httpparser}/* http-parser/
    chmod -R u+w dfxml
    popd
  '';

  prePatch = ''
    substituteInPlace ./bootstrap.sh \
      --replace \ git 'echo git' \
      --replace /bin/rm rm
  '';

  preConfigure = "bash ./bootstrap.sh";

  meta = with stdenv.lib; {
    description = ''TCP stream extractor'';
    license     = licenses.gpl3 ;
    maintainers = with maintainers; [ raskin obadz ];
    platforms   = platforms.linux;
  };
}
