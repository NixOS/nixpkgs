{ stdenv, fetchFromGitHub, fetchurl, python3Packages, git, nmap }:

python3Packages.buildPythonApplication rec {
  version = "0.60.1";
  pname = "homeassistant";

  src = fetchFromGitHub {
    owner = "home-assistant";
    repo = "home-assistant";
    rev = version;
    sha256 = "164a87dh4zxw1a5nmlgwjc1nls0d4jjhdy5pzz43pgnwhhflbph3";
  };

  postPatch = ''
	sed -i 's/yarl==/yarl>=/' setup.py
	sed -i 's/aiohttp==/aiohttp>=/' setup.py
  '';

  propagatedBuildInputs = with python3Packages; [ astral certifi netifaces pip vincenty webcolors pyyaml yarl
                                                  aiohttp-cors voluptuous async-timeout requests aiohttp jinja2
                                                  pytz chardet setuptools_scm typing git nmap ];


 #checkInputs = [ python3Packages.pytest python3Packages.sqlalchemy ];
 # Disable tests for now due to many failing checks caused by network and fs access
 doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://home-assistant.io/;
    description = "An open-source home automation platform running on Python 3";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ f-breidenstein ];
  };
}


