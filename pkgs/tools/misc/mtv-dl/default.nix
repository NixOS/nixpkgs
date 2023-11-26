{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mtv-dl";
  version = "0.23.25";
  pyproject = true;

  src = fetchPypi {
    pname = "mtv_dl";
    inherit version;
    hash = "sha256-zcfYrT4b2hDeNXW2ZKvLGnv5ncEvYyadn3upj/838mY=";
  };

  build-system = with python3.pkgs; [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = with python3.pkgs; [
    beautifulsoup4
    certifi
    docopt
    durationpy
    ijson
    iso8601
    pyyaml
    rich
  ];

  pythonImportsCheck = [ "mtv_dl" ];

  meta = with lib; {
    description = "Command line tool to download videos from sources available through MediathekView";
    homepage = "https://github.com/fnep/mtv_dl";
    license = licenses.mit;
    mainProgram = "mtv_dl";
    maintainers = with maintainers; [ jtrees ];
  };
}
