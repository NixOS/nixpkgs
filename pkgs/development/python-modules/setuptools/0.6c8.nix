
args : with args; 
rec {
  src = fetchurl {
    url = http://pypi.python.org/packages/source/s/setuptools/setuptools-0.6c8.tar.gz;
    sha256 = "0dry431lkaqqmgvka0rhnw54ljf1yx0npzh7r81z2ylcrn27lrln";
  };

  buildInputs = [python];
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["createPythonInstallationTarget" "installPythonPackage"];
      
  name = "setuptools-" + version;
  meta = {
    description = "Installation utilities for Python packages";
  };
}
