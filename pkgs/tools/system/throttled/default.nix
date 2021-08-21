{ lib, stdenv, fetchFromGitHub, python3Packages }:

stdenv.mkDerivation rec {
  pname = "throttled";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "erpalma";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4aDa6REDHO7gr1czIv6NlepeMVJI93agxJjE2vHiEmk=";
  };

  nativeBuildInputs = [ python3Packages.wrapPython ];

  pythonPath = with python3Packages; [
    configparser
    dbus-python
    pygobject3
  ];

  # The upstream unit both assumes the install location, and tries to run in a virtualenv
  postPatch = ''sed -e 's|ExecStart=.*|ExecStart=${placeholder "out"}/bin/lenovo_fix.py|' -i systemd/lenovo_fix.service'';

  installPhase = ''
    runHook preInstall
    install -D -m755 -t $out/bin lenovo_fix.py
    install -D -t $out/bin lenovo_fix.py mmio.py
    install -D -m644 -t $out/etc etc/*
    install -D -m644 -t $out/lib/systemd/system systemd/*
    runHook postInstall
  '';

  postFixup = "wrapPythonPrograms";

  meta = with lib; {
    description = "Fix for Intel CPU throttling issues";
    homepage = "https://github.com/erpalma/throttled";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ michaelpj ];
  };
}
