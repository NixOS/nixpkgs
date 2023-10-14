{ buildPythonPackage
, fetchPypi
, numpy
, omegaconf
, pytorch-lightning
, torch
, torchvision
, tqdm
}:

buildPythonPackage rec {
  pname = "taming-transformers-rom1504";
  version = "0.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cicin81lr1py2wnrw0amnpkdcksk3h7csgf6r1fxk4a230mzzkk";
  };

  propagatedBuildInputs =
    [ torch torchvision numpy tqdm omegaconf pytorch-lightning ];

  # TODO FIXME
  doCheck = false;

  meta = {
    description = "Taming Transformers for High-Resolution Image Synthesis";
  };
}
