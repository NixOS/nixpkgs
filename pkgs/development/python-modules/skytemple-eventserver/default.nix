{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "skytemple-eventserver";
  version = "1.6.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = "skytemple-eventserver";
    rev = version;
    hash = "sha256-PWLGPORNprTfG+jgXI1sxyVkRTwSEib4SZhPdOBchwE=";
  };

  doCheck = false; # there are no tests
  pythonImportsCheck = [ "skytemple_eventserver" ];

  meta = with lib; {
    homepage = "https://github.com/SkyTemple/skytemple-eventserver";
    description = "Websocket server that emits SkyTemple UI events";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ marius851000 ];
  };
}
