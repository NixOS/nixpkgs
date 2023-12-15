{ lib
, buildPythonPackage
, fetchFromGitHub
, future
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "sparklines";
  version = "0.4.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "deeplook";
    repo = pname;
    rev = "v${version}";
    sha256 = "1hfxp5c4wbyddy7fgmnda819w3dia3i6gqb2323dr2z016p84r7l";
  };

  propagatedBuildInputs = [ future ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sparklines" ];

  meta = with lib; {
    description = "This Python package implements Edward Tufte's concept of sparklines, but limited to text only";
    homepage = "https://github.com/deeplook/sparklines";
    maintainers = with maintainers; [ rhoriguchi ];
    license = licenses.gpl3Only;
  };
}
