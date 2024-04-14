{ lib, python3Packages, fetchPypi }:

python3Packages.buildPythonApplication rec {
  pname = "mloader";
  version = "1.1.11";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-SFFjv4RWh1JZtxkDmaun35gKi5xty1ifIItwaz3lot4=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "protobuf~=3.6" "protobuf"
  '';

  propagatedBuildInputs = with python3Packages; [
    click
    protobuf
    requests
  ];

  # No tests in repository
  doCheck = false;

  pythonImportsCheck = [ "mloader" ];

  meta = with lib; {
    description = "Command-line tool to download manga from mangaplus";
    homepage = "https://github.com/hurlenko/mloader";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ marsam ];
    mainProgram = "mloader";
  };
}
