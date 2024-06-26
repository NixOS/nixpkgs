{ lib, python3, fetchPypi }:

python3.pkgs.buildPythonApplication rec {
  pname = "mtv-dl";
  version = "0.23.12";
  format = "pyproject";

  src = fetchPypi {
    pname = "mtv_dl";
    inherit version;
    hash = "sha256-OLDFSoyMztzFs/nMCbLp2WcMJhJ/G3xkkhebe0v8BEo=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
    poetry-dynamic-versioning
  ];

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    docopt
    durationpy
    ijson
    iso8601
    pyyaml
    rich
  ];

  meta = with lib; {
    description = "Command line tool to download videos from sources available through MediathekView";
    homepage = "https://github.com/fnep/mtv_dl";
    license = licenses.mit;
    mainProgram = "mtv_dl";
    maintainers = with maintainers; [ jtrees ];
  };
}
