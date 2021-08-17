{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "gay";
  version = "1.2.8";
  src = fetchPypi {
    inherit pname version;
    sha256 = "07ay0xjjjrm7qxz4c10s5mn2029rqq4m5ai26ypi5dh91al0g0pz";
  };

  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/ms-jpq/gay";
    description = "Colour your text / terminal to be more gay";
    longDescription = ''
      Colour your text / terminal to be more gay.
      Gayer version of lolcat.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ l3gacyb3ta ];
  };
}
