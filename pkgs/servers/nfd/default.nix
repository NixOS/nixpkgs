{ lib
, stdenv
, ndn-cxx
, libpcap
, fetchFromGitHub
, boost
, pkg-config
, openssl
, doxygen
, wafHook
, systemd
, python3
, python3Packages
, websocketpp
, withSystemd ? stdenv.isLinux
, withWebSocket ? true
}:
let
  pythonPackages = p: with p; [ sphinx ];
in
stdenv.mkDerivation rec {
  pname = "nfd";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "named-data";
    repo = lib.toUpper pname;
    rev = "${lib.toUpper pname}-${version}";
    sha256 = "1l9bchj8c68r6qw4vr1kc96jgxl0vpqa2vjkvy1xmhz92sivr6gi";
  };

  nativeBuildInputs = [ wafHook doxygen pkg-config (python3.withPackages pythonPackages) ];
  buildInputs = [ libpcap boost openssl ndn-cxx ] ++ lib.optional withSystemd systemd ++ lib.optional withSystemd websocketpp;

  wafConfigureFlags = [
    "--boost-includes=${boost.dev}/include"
    "--boost-libs=${boost.out}/lib"
  ] ++ lib.optional (!withWebSocket) "--without-websocket";

  meta = with lib; {
    homepage = "http://named-data.net/";
    description = "Named Data Neworking (NDN) Forwarding Daemon";
    license = licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = [ maintainers.bertof ];
  };
}
