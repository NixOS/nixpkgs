{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "i3a";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2k1HYtgJ76qXLvX6RmOSKtMMg+K722n8U9YmBANvQvE=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "python_requires='>=3.7,<3.10'," "python_requires='>=3.7',"
  '';

  nativeBuildInputs = [ python3Packages.setuptools-scm ];

  propagatedBuildInputs = [ python3Packages.i3ipc ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://git.goral.net.pl/mgoral/i3a";
    description = "A set of scripts used for automation of i3 and sway window manager layouts";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ moni ];
  };
}
