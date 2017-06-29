{ stdenv, fetchFromGitHub, doxygen, boost, pkgconfig, python, pythonPackages,
  libpcap, openssl, ndn-cxx }:
let
  version = "0.5.1";
in
stdenv.mkDerivation {
  name = "nfd-${version}";
  src = fetchFromGitHub {
    owner = "named-data";
    repo = "NFD";
    rev = "NFD-${version}";
    sha256 = "1qd02xr7iic0d9mca1m2ps1cxb7z3hj7llmyvxx0fc1jl8djvy9z";
  };
  buildInputs = [ libpcap doxygen boost pkgconfig python pythonPackages.sphinx
                  openssl ndn-cxx ];
  preConfigure = ''
    patchShebangs waf
    ./waf configure \
      --boost-includes="${boost.dev}/include" \
      --boost-libs="${boost.out}/lib" \
      --without-websocket \
      --prefix="$out"
  '';
  buildPhase = ''
    ./waf
  '';
  installPhase = ''
    ./waf install
  '';
  # Even though there are binaries, they don't get put in "bin" by default, so
  # this ordering seems to be a better one. ~ C.
  outputs = [ "out" "dev" "doc" ];
  meta = with stdenv.lib; {
    homepage = "http://named-data.net/";
    description = "Named Data Neworking (NDN) Forwarding Daemon";
    license = licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ maintainers.MostAwesomeDude ];
  };
}
