{ lib, python3Packages, fetchFromGitHub, gettext }:

python3Packages.buildPythonPackage rec {
  pname = "ibus-theme-tools";
  version = "4.2.0";
  disabled = python3Packages.pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = "IBus-Theme-Tools";
    rev = "v${version}";
    sha256 = "0i8vwnikwd1bfpv4xlgzc51gn6s18q58nqhvcdiyjzcmy3z344c2";
  };

  propagatedBuildInputs = [ python3Packages.tinycss2 python3Packages.pygobject3 gettext ];

  # No test.
  doCheck = false;

  meta = with lib; {
    description = "Generate the IBus GTK or GNOME Shell theme from existing themes";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hollowman6 ];
    homepage = "https://github.com/openSUSE/IBus-Theme-Tools";
  };
}
