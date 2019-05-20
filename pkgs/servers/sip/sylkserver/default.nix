{ stdenv, fetchFromGitHub, python2, python2Packages }:

python2Packages.buildPythonApplication rec {
  pname = "sylkserver";
  version = "5.5.0";

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = "sylkserver";
    rev = "release-${version}";
    hash = "sha256-8ngqq5zxWdjFaNts/rQkC4uuc/k0umBnFwLHm/dPajo=";
  };

  propagatedBuildInputs = with python2Packages; [
    application
    autobahn
    eventlib
    klein
    lxml
    pyopenssl
    service-identity
    sipsimple
    twisted
    typing
  ];

  meta = with stdenv.lib; {
    description = "SIP/WebRTC Application Server";
    longDescription = ''
      Extensible real-time-communications application server SylkServer is a
      SIP applications server that provides applications like echo, playback
      and conference, as well as act as a gateway between SIP and IRC, XMPP
      and WEBRTC.
    '';
    homepage = "http://sylkserver.com";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ zimbatm ];
  };
}
