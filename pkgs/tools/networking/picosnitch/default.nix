{ lib
, python3
, fetchPypi
, bcc
}:

python3.pkgs.buildPythonApplication rec {
  pname = "picosnitch";
  version = "0.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b58255a78a0bf652224ee22ca83137d75ea77b7eb1ad2d11159b56b6788f6201";
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
