{ lib, python3Packages, ffmpeg }:

python3Packages.buildPythonApplication rec {
  pname = "vcsi";
  version = "7.0.12";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0dks0yr2a0cpr32vrwhdrhsb4qyj7rz1yv44fjbr8z8j8p84yjx5";
  };

  propagatedBuildInputs = with python3Packages; [
    numpy
    pillow
    jinja2
    texttable
    parsedatetime
  ];

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ ffmpeg ]}" ];

  meta = with lib; {
    description = "Create video contact sheets";
    homepage = "https://github.com/amietn/vcsi";
    license = licenses.mit;
    maintainers = with maintainers; [ dandellion ];
  };
}
