{ buildPythonPackage
, lib
, fetchPypi
, ruamel_yaml
, python-dateutil
}:

buildPythonPackage rec {
  version = "1.0.3";
  pname = "strictyaml";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05masza4jvvnh2msswpx4l29w1pv92zpy473yd2ndwcclcrk3rli";
  };

  propagatedBuildInputs = [ ruamel_yaml python-dateutil ];

  # Library tested with external tool
  # https://hitchdev.com/approach/contributing-to-hitch-libraries/
  doCheck = false;

  meta = with lib; {
    description = "Strict, typed YAML parser";
    homepage = https://hitchdev.com/strictyaml/;
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
