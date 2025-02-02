{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  dask,
  pandas,
  psutil,
  tqdm,
  ipywidgets,
  ray,
}:

buildPythonPackage rec {
  pname = "swifter";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jmcarpenter2";
    repo = "swifter";
    rev = "refs/tags/${version}";
    hash = "sha256-lgdf8E9GGjeLY4ERzxqtjQuYVtdtIZt2HFLSiNBbtX4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pandas
    psutil
    dask
    tqdm
  ] ++ dask.optional-dependencies.dataframe;

  optional-dependencies = {
    groupby = [ ray ];
    notebook = [ ipywidgets ];
  };

  pythonImportsCheck = [ "swifter" ];

  # tests may hang due to ignoring cpu core limit
  # https://github.com/jmcarpenter2/swifter/issues/221
  doCheck = false;

  meta = {
    description = "Package which efficiently applies any function to a pandas dataframe or series in the fastest available manner";
    homepage = "https://github.com/jmcarpenter2/swifter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
