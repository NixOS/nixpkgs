{ lib
, stdenv
, ndn-cxx
, openssl
, doxygen
, boost
, sqlite
, pkgconfig
, python3
, python3Packages
, wafHook
, libpcap
, fetchFromGitHub
}:
let
  pname = "ndn-tools";
  version = "0.7.1";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "named-data";
    repo = pname;
    rev = "${pname}-${version}";
    sha256 = "1q2d0v8srqjbvigr570qw6ia0d9f88aj26ccyxkzjjwwqdx3y4fy";
  };

  nativeBuildInputs = [ pkgconfig wafHook doxygen python3 python3Packages.sphinx ];
  buildInputs = [ ndn-cxx boost libpcap openssl ];

  wafConfigureFlags = [
    "--boost-includes=${boost.dev}/include"
    "--boost-libs=${boost.out}/lib"
    # "--with-tests"
  ];

  # Upstream's tests don't all pass!
  doCheck = false;
  checkPhase = ''
    LD_LIBRARY_PATH=build/ build/unit-tests
  '';

  # outputs = [ "dev" "out" ];

  meta = with lib; {
    homepage = "http://named-data.net/";
    description = "Named Data Neworking (NDN) Essential Tools";
    license = licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with maintainers; [ bertof ];
  };
}
