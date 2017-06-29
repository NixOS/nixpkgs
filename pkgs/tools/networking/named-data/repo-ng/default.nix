{ stdenv, fetchFromGitHub, openssl, doxygen, boost, sqlite, pkgconfig,
  python, pythonPackages, libpcap, ndn-cxx }:
let
  version = "42290b";
in
stdenv.mkDerivation {
  name = "repo-ng-0.1-${version}";
  src = fetchFromGitHub {
    owner = "named-data";
    repo = "repo-ng";
    rev = "42290b2b12b06ccbb028f04367f016f924f213e3";
    sha256 = "0xlgc6ahswpjq1fbxs5kr7xh0ilbkz7vpwaildd8fcglvi2814yn";
  };
  buildInputs = [ libpcap openssl doxygen boost sqlite pkgconfig
                  python pythonPackages.sphinx ndn-cxx ];
  preConfigure = ''
    patchShebangs waf
    ./waf configure \
      --boost-includes="${boost.dev}/include" \
      --boost-libs="${boost.out}/lib" \
      --with-tests \
      --prefix="$out"
  '';
  buildPhase = ''
    ./waf
  '';
  # The tests can run but may fail. ~ C.
  doCheck = false;
  checkPhase = ''
    build/unit-tests
  '';
  installPhase = ''
    ./waf install
  '';
  # NB: Outputs not split because there's only binaries in the output. ~ C.
  meta = with stdenv.lib; {
    homepage = "http://named-data.net/";
    description = "Named Data Neworking (NDN) Repo";
    license = licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ maintainers.MostAwesomeDude ];
  };
}
