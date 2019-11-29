{ stdenv, lib, fetchFromGitHub, cmake, pkgconfig, boost
, log4cpp, pjsip, openssl, alsaLib, mumlib }:
with lib; stdenv.mkDerivation {
  pname = "mumsi";
  version = "unstable-2018-12-12";

  src = fetchFromGitHub {
    owner = "slomkowski";
    repo = "mumsi";
    rev = "961b75792f8da22fb5502e39edb286e32172d0b0";
    sha256 = "0vrivl1fiiwjsz4v26nrn8ra3k9v0mcz7zjm2z319fw8hv6n1nrk";
  };

  buildInputs = [ boost log4cpp pkgconfig pjsip mumlib openssl alsaLib ];
  nativeBuildInputs = [ cmake pkgconfig ];
  installPhase = ''
    install -Dm555 mumsi $out/bin/mumsi
  '';

  meta = {
    description = "SIP to Mumble gateway/bridge using PJSUA stack";
    homepage = "https://github.com/slomkowski/mumsi";
    maintainers = with maintainers; [ das_j ];
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
