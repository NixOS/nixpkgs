{ stdenv, pythonPackages, fetchFromGitHub }:

pythonPackages.buildPythonApplication rec {
  pname = "ntfy";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "dschep";
    repo = "ntfy";
    rev = "v${version}";
    sha256 = "09f02cn4i1l2aksb3azwfb70axqhn7d0d0vl2r6640hqr74nc1cv";
  };

  checkInputs = with pythonPackages; [
    mock
  ];

  propagatedBuildInputs = with pythonPackages; [
    requests ruamel_yaml appdirs
    sleekxmpp dns
    emoji
    psutil
    matrix-client
    dbus-python
  ];

  checkPhase = ''
    HOME=$(mktemp -d) ${pythonPackages.python.interpreter} setup.py test
  '';

  meta = with stdenv.lib; {
    description = "A utility for sending notifications, on demand and when commands finish";
    homepage = http://ntfy.rtfd.org/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ jfrankenau kamilchm ];
  };
}
