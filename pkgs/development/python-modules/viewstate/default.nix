{ buildPythonPackage
, fetchPypi
, lib
}:

buildPythonPackage rec {
  pname = "viewstate";
  version = "0.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p5p5cp76m04klp7awyx8knqrd5sklgl9lvqirrbsdvkkig2fsl5";
  };

  doCheck = false;

  meta = {
    description = ".NET viewstate decoder";
    homepage = "https://github.com/yuvadm/viewstate";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kamadorueda
    ];
  };
}
