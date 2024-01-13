{ lib
, python3
, fetchPypi
, bcc
}:

python3.pkgs.buildPythonApplication rec {
  pname = "picosnitch";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5d427eb46de448e4109f68ed435dd38426df8200aea5bb668639aabe1f0b4580";
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
    geoip2
  ];

  postInstall = ''
    substituteInPlace $out/${python3.sitePackages}/picosnitch.py --replace '/run/picosnitch.pid' '/run/picosnitch/picosnitch.pid'
  '';

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
