{stdenv, fetchurl, yacc }:

stdenv.mkDerivation rec {
  name = "spin-${version}";
  version = "6.4.5";
  url-version = stdenv.lib.replaceChars ["."] [""] version;

  src = fetchurl {
    # The homepage is behind CloudFlare anti-DDoS protection, which blocks cURL.
    # Dropbox mirror from developers:
    # https://www.dropbox.com/sh/fgzipzp4wpo3qc1/AADZPqS4aoR-pjNF6OQXRLQHa
    url = "https://www.dropbox.com/sh/fgzipzp4wpo3qc1/AAANRpxsSyWC7iHZB-XgBwJFa/spin645.tar.gz?raw=1";
    sha256 = "0x8qnwm2xa8f176c52mzpvnfzglxs6xgig7bcgvrvkb3xf114224";
  };

  buildInputs = [ yacc ];

  sourceRoot = "Spin/Src${version}";

  installPhase = "install -D spin $out/bin/spin";

  meta = with stdenv.lib; {
    description = "Formal verification tool for distributed software systems";
    homepage = http://spinroot.com/;
    license = licenses.free;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mornfall pSub ];
  };
}
