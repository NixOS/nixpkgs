{ lib
, python3
, bcc
}:

python3.pkgs.buildPythonApplication rec {
  pname = "picosnitch";
  version = "0.12.0";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "b87654b4b92e28cf5418388ba1d3165b9fa9b17ba91af2a1a942f059128f68bc";
  };

  propagatedBuildInputs = with python3.pkgs; [
    setuptools
    bcc
    psutil
    dbus-python
    requests
    pandas
    plotly
    dash
  ];

  patches = [ ./picosnitch.patch ];

  pythonImportsCheck = [ "picosnitch" ];

  meta = with lib; {
    description = "Monitor network traffic per executable with hashing";
    homepage = "https://github.com/elesiuta/picosnitch";
    changelog = "https://github.com/elesiuta/picosnitch/releases";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.elesiuta ];
    platforms = platforms.linux;
  };
}
