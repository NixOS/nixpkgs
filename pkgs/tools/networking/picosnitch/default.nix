{ lib
, python3
<<<<<<< HEAD
, fetchPypi
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, bcc
}:

python3.pkgs.buildPythonApplication rec {
  pname = "picosnitch";
<<<<<<< HEAD
  version = "0.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b58255a78a0bf652224ee22ca83137d75ea77b7eb1ad2d11159b56b6788f6201";
=======
  version = "0.12.0";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "b87654b4b92e28cf5418388ba1d3165b9fa9b17ba91af2a1a942f059128f68bc";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    geoip2
  ];

  postInstall = ''
    substituteInPlace $out/${python3.sitePackages}/picosnitch.py --replace '/run/picosnitch.pid' '/run/picosnitch/picosnitch.pid'
  '';
=======
  ];

  patches = [ ./picosnitch.patch ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
