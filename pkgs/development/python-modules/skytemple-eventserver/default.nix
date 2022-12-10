{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "skytemple-eventserver";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "SkyTemple";
    repo = pname;
    rev = version;
    sha256 = "1xcf7ljvi5ixhwx9rkg3hnwcyv4wsgd2yb6is11jffbrdp00j2bq";
  };

  doCheck = false; # there are no tests
  pythonImportsCheck = [ "skytemple_eventserver" ];

  meta = with lib; {
    homepage = "https://github.com/SkyTemple/skytemple-eventserver";
    description = "Websocket server that emits SkyTemple UI events";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ xfix ];
  };
}
