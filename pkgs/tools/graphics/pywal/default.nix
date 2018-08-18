{ lib, python3Packages, imagemagick, feh }:

python3Packages.buildPythonApplication rec {
  pname = "pywal";
  version = "3.1.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "1i4i9jjnm4f0zhz4nqbb4253517w33bsh5f246n5930hwrr9xn76";
  };

  # necessary for imagemagick to be found during tests
  buildInputs = [ imagemagick ];

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ imagemagick feh ]}" ];

  preCheck = ''
    mkdir tmp
    HOME=$PWD/tmp
  '';

  meta = with lib; {
    description = "Generate and change colorschemes on the fly. A 'wal' rewrite in Python 3.";
    homepage = https://github.com/dylanaraps/pywal;
    license = licenses.mit;
    maintainers = with maintainers; [ Fresheyeball ];
  };
}
