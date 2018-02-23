{ stdenv, fetchurl, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "autokey";
  version  = "0.94.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/autokey/autokey/archive/v${version}.tar.gz";
    sha256 = "619c5b93c015ab79176f98d6a0a17f14706cf23e9b79d5ffc5c0295b2ec88612";
  };

  propagatedBuildInputs = with python3Packages; [ xlib pyinotify dbus-python ];

  pythonPath = with python3Packages;
                  [ dbus-python ];

  meta = with stdenv.lib; {
    description = "Autokey";
    homepage = https://github.com/autokey/autokey;
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
