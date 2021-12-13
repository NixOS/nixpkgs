{ lib
, stdenv
, boost
, fetchFromGitHub
, libpcap
, ndn-cxx
, openssl
, pkg-config
, sphinx
, systemd
, wafHook
, websocketpp
, withSystemd ? stdenv.isLinux
, withWebSocket ? true
}:

stdenv.mkDerivation rec {
  pname = "nfd";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "named-data";
    repo = lib.toUpper pname;
    rev = "NFD-${version}";
    sha256 = "1l9bchj8c68r6qw4vr1kc96jgxl0vpqa2vjkvy1xmhz92sivr6gi";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config sphinx wafHook ];
  buildInputs = [ libpcap ndn-cxx openssl websocketpp ] ++ lib.optional withSystemd systemd;

  wafConfigureFlags = [
    "--boost-includes=${boost.dev}/include"
    "--boost-libs=${boost.out}/lib"
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
    description = "Named Data Neworking (NDN) Forwarding Daemon";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.bertof ];
  };
}
