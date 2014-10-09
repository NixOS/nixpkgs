{stdenv, fetchurl, yacc }:

stdenv.mkDerivation rec {
  name = "spin-${version}";
  version = "6.4.1";
  url-version = stdenv.lib.replaceChars ["."] [""] version;

  src = fetchurl {
    url = "http://spinroot.com/spin/Src/spin${url-version}.tar.gz";
    curlOpts = "--user-agent 'Mozilla/5.0'";
    sha256 = "02r2jazb2hnhcqcjnmlj6sjd9dvyfalgi99bzncwfadixf3hmpvn";
  };

  buildInputs = [ yacc ];

  sourceRoot = "Spin/Src${version}";

  installPhase = "install -D spin $out/bin/spin";

  meta = with stdenv.lib; {
    description = "Formal verification tool for distributed software systems";
    homepage = http://spinroot.com/;
    license = "free";
    maintainers = with maintainers; [ mornfall pSub ];
  };
}
