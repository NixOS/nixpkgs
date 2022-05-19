{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ttp-templates";
  version = "0.1.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dmulyalin";
    repo = "ttp_templates";
    rev = version;
    hash = "sha256-Qx+z/srYgD67FjXzYrc8xtA99n8shWK7yWj/r/ETN2U=";
  };

  postPatch = ''
    # Drop circular dependency on ttp
    substituteInPlace setup.py \
      --replace '"ttp>=0.6.0"' ""
  '';

  # Circular dependency on ttp
  doCheck = false;

  meta = with lib; {
    description = "Template Text Parser Templates collections";
    homepage = "https://github.com/dmulyalin/ttp_templates";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
