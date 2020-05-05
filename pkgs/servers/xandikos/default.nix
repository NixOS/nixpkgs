{ stdenv
, fetchFromGitHub
, python3Packages
}:

python3Packages.buildPythonApplication rec {
  pname = "xandikos";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "jelmer";
    repo = "xandikos";
    rev = "v${version}";
    sha256 = "0bcihkfi75wg0s2an2hysrcrg6pbqqclia53l0vhkzg9b5b8cga1";
  };

  propagatedBuildInputs = with python3Packages; [
    aiohttp
    dulwich
    defusedxml
    icalendar
    jinja2
    multidict
    prometheus_client
  ];

  meta = with stdenv.lib; {
    description = "Lightweight CalDAV/CardDAV server";
    homepage = "https://github.com/jelmer/xandikos";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers."0x4A6F" ];
  };
}

