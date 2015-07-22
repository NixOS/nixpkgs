{stdenv, fetchurl, yacc }:

stdenv.mkDerivation rec {
  name = "spin-${version}";
  version = "6.4.3";
  url-version = stdenv.lib.replaceChars ["."] [""] version;

  src = fetchurl {
    url = "http://spinroot.com/spin/Src/spin${url-version}.tar.gz";
    curlOpts = "--user-agent 'Mozilla/5.0'";
    sha256 = "0cldhxvfw6llh4spcx0x0535pffx89pvvxpdi0bpqy9a6da85ln1";
  };

  buildInputs = [ yacc ];

  sourceRoot = "Spin/Src${version}";

  installPhase = "install -D spin $out/bin/spin";

  meta = with stdenv.lib; {
    description = "Formal verification tool for distributed software systems";
    homepage = http://spinroot.com/;
    license = stdenv.lib.licenses.free;
    maintainers = with maintainers; [ mornfall pSub ];
  };
}
