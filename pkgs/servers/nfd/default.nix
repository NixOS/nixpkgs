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
  version = "24.07";

  src = fetchFromGitHub {
    owner = "named-data";
    repo = lib.toUpper pname;
    rev = "NFD-${version}";
    hash = "sha256-iEI8iS0eLLVe6PkOiCHL3onYNVYVZ1ttmk/aWrBkDhg=";
    fetchSubmodules = true;
  };

  postPatch = ''
    # These tests fail because they try to check for user/group permissions.
    rm tests/daemon/mgmt/general-config-section.t.cpp
  '';

  nativeBuildInputs = [ pkg-config sphinx wafHook ];
  buildInputs = [ boost179 libpcap ndn-cxx openssl websocketpp ] ++ lib.optional withSystemd systemd;

  wafConfigureFlags = [
    "--boost-includes=${boost179.dev}/include"
    "--boost-libs=${boost179.out}/lib"
    "--with-tests"
  ] ++ lib.optional (!withWebSocket) "--without-websocket";

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    build/unit-tests-core
    build/unit-tests-daemon
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
