{ lib
, stdenv
, boost175
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
    sha256 = "sha256-8Zm8oxbpw9qD31NuofDdgPYnTWIz5E04NhkZhiRkK9E=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config sphinx wafHook ];
  buildInputs = [ libpcap ndn-cxx openssl websocketpp ] ++ lib.optional withSystemd systemd;

  wafConfigureFlags = [
    "--boost-includes=${boost175.dev}/include"
    "--boost-libs=${boost175.out}/lib"
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
    maintainers = [ lib.maintainers.bertof ];
  };
}
