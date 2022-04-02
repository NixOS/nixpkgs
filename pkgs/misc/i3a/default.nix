{ lib, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "i3a";
  version = "2.0.1";

  src = python3Packages.fetchPypi {
    inherit pname version;
    hash = "sha256-2k1HYtgJ76qXLvX6RmOSKtMMg+K722n8U9YmBANvQvE=";
  };

  nativeBuildInputs = [ python3Packages.setuptools-scm ];
  propagatedBuildInputs = [ python3Packages.i3ipc ];

  meta = with lib; {
    homepage = "https://git.goral.net.pl/mgoral/i3a";
    description = "A set of scripts used for automation of i3 and sway window manager layouts";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
