{ lib, fetchFromGitHub, python3 }:

python3.pkgs.buildPythonPackage rec {
  pname = "python-validity";
  version = "0.12";

  src = fetchFromGitHub {
    owner = "uunicorn";
    repo = pname;
    rev = version;
    sha256 = "sha256-s0o99CRW9gwxCv3AMKrtXh8mrblVAA9r9IIPgy6fv4U=";
  };

  buildInputs = with python3.pkgs; [ cryptography pyyaml pyusb ];

  propagatedBuildInputs = with python3.pkgs; [
    dbus-python
    pygobject3
    cryptography
    pyyaml
    pyusb
  ];

  postInstall = ''
    install -D -m 644 debian/python3-validity.service \
      $out/lib/systemd/system/python3-validity.service
    substituteInPlace $out/lib/python-validity/dbus-service \
      --replace /usr/share/python-validity/backoff /tmp/backoff
    substituteInPlace $out/${python3.sitePackages}/validitysensor/sensor.py \
      --replace /usr/share/python-validity/calib-data.bin /tmp/calib-data.bin
    substituteInPlace $out/lib/systemd/system/python3-validity.service \
      --replace /usr/lib/python-validity "$out/lib/python-validity"
  '';

  postFixup = ''
    wrapPythonProgramsIn "$out/lib/python-validity" "$out $pythonPath"
  '';

  meta = with lib; {
    description = "Validity fingerprint sensor driver";
    homepage = "https://github.com/uunicorn/python-validity";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
