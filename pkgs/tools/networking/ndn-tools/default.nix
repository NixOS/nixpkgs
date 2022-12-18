{ lib
, stdenv
, boost175
, fetchFromGitHub
, libpcap
, ndn-cxx
, openssl
, pkg-config
, sphinx
, wafHook
}:

stdenv.mkDerivation rec {
  pname = "ndn-tools";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "named-data";
    repo = pname;
    rev = "ndn-tools-${version}";
    sha256 = "sha256-3hE/esOcS/ln94wZIRVCLjWgouEYnJJf3EvirNEGTeA=";
  };

  nativeBuildInputs = [ pkg-config sphinx wafHook ];
  buildInputs = [ libpcap ndn-cxx openssl ];

  wafConfigureFlags = [
    "--boost-includes=${boost175.dev}/include"
    "--boost-libs=${boost175.out}/lib"
    # "--with-tests"
  ];

  doCheck = false;
  checkPhase = ''
    runHook preCheck
    build/unit-tests
    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://named-data.net/";
    description = "Named Data Networking (NDN) Essential Tools";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bertof ];
  };
}
