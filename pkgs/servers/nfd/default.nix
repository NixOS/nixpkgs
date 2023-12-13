{ lib
, stdenv
, boost179 # probably needs to match the one from ndn-cxx
, fetchFromGitHub
, libpcap
, ndn-cxx
, openssl
, pkg-config
, sphinx
, systemd
, wafHook
, websocketpp
, withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd
, withWebSocket ? true
}:

stdenv.mkDerivation rec {
  pname = "nfd";
  version = "22.12";

  src = fetchFromGitHub {
    owner = "named-data";
    repo = lib.toUpper pname;
    rev = "NFD-${version}";
    sha256 = "sha256-epY5qtET7rsKL3KIKvxfa+wF+AGZbYs+zRhy8SnIffk=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config sphinx wafHook ];
  buildInputs = [ libpcap ndn-cxx openssl websocketpp ] ++ lib.optional withSystemd systemd;

  wafConfigureFlags = [
    "--boost-includes=${boost179.dev}/include"
    "--boost-libs=${boost179.out}/lib"
    "--with-tests"
  ] ++ lib.optional (!withWebSocket) "--without-websocket";

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    build/unit-tests-core
    # build/unit-tests-daemon # 3 tests fail
    build/unit-tests-rib
    build/unit-tests-tools
    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://named-data.net/";
    description = "Named Data Networking (NDN) Forwarding Daemon";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bertof ];
  };
}
