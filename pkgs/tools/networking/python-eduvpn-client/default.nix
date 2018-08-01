{ stdenv, fetchFromGitHub, gdk_pixbuf, gobjectIntrospection, gtk3
, libnotify, networkmanager_openvpn, pythonPackages, wrapGAppsHook }:

pythonPackages.buildPythonApplication rec {
  pname = "eduvpn-client";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "eduvpn";
    repo = "python-${pname}";
    rev = version;
    sha256 = "1jy8dv6i8rhmz5q59xcmwmf5n4bpfchkm4xjc1yi1x77qy8gi7bv";
  };

  prePatch = ''
    substituteInPlace eduvpn/util.py \
      --replace "/usr/local" "$out"
  '';

  checkInputs = with pythonPackages; [ pytest mock pytestrunner ];
  nativeBuildInputs = with pythonPackages; [ wrapGAppsHook ];

  propagatedBuildInputs = with pythonPackages; [
    # Non-Python Dependencies
    gdk_pixbuf gobjectIntrospection gtk3 libnotify networkmanager_openvpn
    # Python Dependencies
    configparser dateutil dbus-python future pygobject3 pynacl requests
    requests_oauthlib six repoze_lru pillow qrcode pytestrunner
    ];

  # Checks need X environment
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://eduvpn.org;
    description = "Linux client and Python client API for eduVPN";
    longDescription = ''
      This is the GNU/Linux desktop client and Python API for eduVPN.
      The Desktop client only works on Linux, but most parts of the
      API are usable on other platforms also. For the API Python 2.7,
      3.4+ and pypy are supported.
    '';
    license = licenses.gpl3;
    maintainers = with maintainers; [ leenaars ];
    platforms = platforms.linux;
  };
}
