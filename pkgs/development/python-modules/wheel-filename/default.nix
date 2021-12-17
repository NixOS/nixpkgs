{ lib
, buildPythonPackage
, fetchurl
, attrs
}:

buildPythonPackage rec {
  pname = "wheel-filename";
  version = "1.3.0";
  format = "wheel";

  src = fetchurl {
    url = "https://github.com/jwodder/wheel-filename/releases/download/v1.1.0/wheel_filename-1.1.0-py3-none-any.whl";
    sha256 = "0aee45553f34e3a1b8a5db64aa832326f13c138b7f925a53daf96f984f9e6a38";
  };

  buildInputs = [
    attrs
  ];

  meta = with lib; {
    homepage = "https://github.com/jwodder/wheel-filename";
    description = "Parse wheel filenames";
    license = with licenses; [ mit ];
    maintainers = with lib.maintainers; [ ayazhafiz ];
  };
}
