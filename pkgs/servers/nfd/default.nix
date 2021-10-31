{ lib
, stdenv
, ndn-cxx
, libpcap
, fetchFromGitHub
, boost
, pkgconfig
, openssl
, doxygen
, wafHook
, systemd
, python3
, python3Packages
, withSystemd ? true
, withWebSocket ? true
}:
let
  pname = "nfd";
  version = "0.7.1";
  pythonPackages = p: with p; [ sphinx ];
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "named-data";
    repo = lib.toUpper pname;
    rev = "${lib.toUpper pname}-${version}";
    sha256 = "1l9bchj8c68r6qw4vr1kc96jgxl0vpqa2vjkvy1xmhz92sivr6gi";
    fetchSubmodules = withWebSocket;
  };

  nativeBuildInputs = [ wafHook doxygen pkgconfig python3 python3Packages.sphinx ];
  buildInputs = [ libpcap boost openssl ndn-cxx ] ++ lib.optional withSystemd systemd;

  wafConfigureFlags = [
    "--boost-includes=${boost.dev}/include"
    "--boost-libs=${boost.out}/lib"
  ] ++ lib.optional (!withWebSocket) "--without-websocket";

  outputs = [ "out" "dev" ];
  meta = with lib; {
    homepage = "http://named-data.net/";
    description = "Named Data Neworking (NDN) Forwarding Daemon";
    license = licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = [ maintainers.bertof ];
  };
}
