{ stdenv, fetchFromGitHub, wafHook, openssl, doxygen, boost, sqlite, pkgconfig,
  python, pythonPackages, libpcap, ndn-cxx }:
let
  version = "3c8431";
in
stdenv.mkDerivation {
  name = "repo-ng-0.1-${version}";
  src = fetchFromGitHub {
    owner = "named-data";
    repo = "repo-ng";
    rev = "3c843162f812ea22972d82fe7a834fac3f3ae2d5";
    sha256 = "0pdinvq3cf458bmm2mxdlidrmmr38in1563ra8q0ch3wp45va2di";
  };
  buildInputs = [ wafHook libpcap openssl doxygen boost sqlite pkgconfig
                  python pythonPackages.sphinx ndn-cxx ];
  wafConfigureFlags = [
    "--boost-includes=${boost.dev}/include"
    "--boost-libs=${boost.out}/lib"
    "--with-tests"
  ];
  # The tests can run but may fail. ~ C.
  doCheck = false;
  checkPhase = ''
    build/unit-tests
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
