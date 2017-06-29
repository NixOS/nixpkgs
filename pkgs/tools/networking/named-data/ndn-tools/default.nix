{ stdenv, fetchFromGitHub, openssl, boost, pkgconfig,
  python, pythonPackages, libpcap, git, ndn-cxx }:
let
  version = "0.4";
in stdenv.mkDerivation {
  name = "ndn-tools-${version}";

  src = fetchFromGitHub {
    owner = "named-data";
    repo = "ndn-tools";
    rev = "ndn-tools-${version}";
    sha256 = "19mrsbhv67ps3l2c8hds9d0gwjawpq1a3jnb917qqig0n6zs29vz";
  };

  buildInputs = [ libpcap openssl boost pkgconfig python pythonPackages.sphinx git ndn-cxx ];
  preConfigure = ''
    patchShebangs waf
    ./waf configure \
      --boost-includes="${boost.dev}/include" \
      --boost-libs="${boost.out}/lib" \
      --prefix="$out"
  '';
  buildPhase = ''
    ./waf
  '';
  installPhase = ''
    ./waf install
  '';
  outputs = [ "out" "dev" "doc" ];
  meta = with stdenv.lib; {
    homepage = "http://named-data.net/";
    description = "Named Data Neworking (NDN) Essential Tools";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.MostAwesomeDude ];
  };
}
