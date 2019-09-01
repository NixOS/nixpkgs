{ stdenv, fetchFromGitHub, wafHook, doxygen, boost, pkgconfig, python, pythonPackages,
  libpcap, openssl, ndn-cxx }:
let
  version = "0.6.6";
in
stdenv.mkDerivation {
  name = "nfd-${version}";
  src = fetchFromGitHub {
    owner = "named-data";
    repo = "NFD";
    rev = "NFD-${version}";
    sha256 = "0y86x9h6wk2n9cfxgnmm0h89kjdv01i7pbf189354yc2ylndmbgh";
  };
  buildInputs = [ wafHook
                  libpcap doxygen boost pkgconfig python pythonPackages.sphinx
                  openssl ndn-cxx ];
  wafConfigureFlags = [
     "--boost-includes=${boost.dev}/include"
     "--boost-libs=${boost.out}/lib"
     "--without-websocket"
  ];
  # Even though there are binaries, they don't get put in "bin" by default, so
  # this ordering seems to be a better one. ~ C.
  outputs = [ "out" "dev" ];
  meta = with stdenv.lib; {
    homepage = "http://named-data.net/";
    description = "Named Data Neworking (NDN) Forwarding Daemon";
    license = licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ maintainers.MostAwesomeDude ];
  };
}
