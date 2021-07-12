{ lib, python3Packages, ffmpeg }:

python3Packages.buildPythonApplication rec {
  pname = "vcsi";
  version = "7.0.13";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "01qwbb2l8gwf622zzhh0kzdzw3njvsdwmndwn01i9bn4qm5cas8r";
  };

  propagatedBuildInputs = with python3Packages; [
    numpy
    pillow
    jinja2
    texttable
    parsedatetime
  ];

  doCheck = false;
  pythonImportsCheck = [ "vcsi" ];

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ ffmpeg ]}" ];

  meta = with lib; {
    description = "Create video contact sheets";
    homepage = "https://github.com/amietn/vcsi";
    license = licenses.mit;
    maintainers = with maintainers; [ dandellion ];
  };
}
