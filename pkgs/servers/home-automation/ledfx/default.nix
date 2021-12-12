{ lib
, fetchFromGitHub
, python3
}:

let
  pname = "ledfx";
  version = "0.10.7";
in
python3.pkgs.buildPythonApplication {
  inherit pname version;
  format = "setuptools";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    hash = "sha256:1vm4h62m0ha6i256ggzapv87mzps3x7ji4qwz6gjn60byigg8x6k";
  };

  patches = [
    ./drop-pyupdater.patch
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "aiohttp~=3.7.4.post0" "aiohttp" \
      --replace "sacn==1.5.0" "sacn" \
      --replace "sentry-sdk~=1.1.0" "sentry-sdk" \
      --replace "zeroconf<=0.28.8||>=0.30.0" "zeroconf" \
      --replace '"pyupdater>=4.0.0",' ""
  '';

  propagatedBuildInputs = with python3.pkgs; [
    aiohttp
    aiohttp-jinja2
    aubio
    cython
    multidict
    numpy
    pyaudio
    pyserial
    pyyaml
    requests
    sacn
    sentry-sdk
    voluptuous
    zeroconf
  ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "LedFx instantaneously transforms audio input into a realtime light show";
    longDescription = ''
      LedFx is a real-time music visualization program that streams audio reactive effects to networked LED strips. LedFx can control multiple devices and works great with cheap ESP8266/ESP32 nodes, allowing for cost effective synchronized effects across your entire house!
    '';
    homepage = "https://ledfx.app";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
