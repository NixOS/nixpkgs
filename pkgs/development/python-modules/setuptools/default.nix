a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "0.6c9" a; 
  buildInputs = with a; [
    python makeWrapper
  ];
in
rec {
  name = "setuptools-" + version;

  src = fetchurl {
    url = "http://pypi.python.org/packages/source/s/setuptools/${name}.tar.gz";
    sha256 = "1n5k6hf9nn69fnprgsnr9hdxzj2j6ir76qcy9d4b2v0v62bh86g6";
  };

  inherit buildInputs;
  configureFlags = [];

  doCheck = true;

  doMakeCheck = a.fullDepEntry (''
    python setup.py test
  '') ["minInit" "doUnpack" "addInputs" "doBuild"];

  doBuild = a.fullDepEntry(''
    python setup.py build --build-base $out
  '') ["addInputs" "doUnpack"];

  doInstall = a.fullDepEntry(''
    ensureDir "$out/lib/python2.5/site-packages"

    PYTHONPATH="$out/lib/python2.5/site-packages:$PYTHONPATH" \
    python setup.py install --prefix="$out"

    for i in "$out/bin/"*
    do
      wrapProgram "$i"                          \
        --prefix PYTHONPATH ":"			\
          "$out/lib/python2.5/site-packages"
    done
  '') ["doBuild"];

  phaseNames = ["doBuild" "doInstall"];

  meta = {
    description = "Utilities to facilitate the installation of Python packages";
    homepage = http://pypi.python.org/pypi/setuptools;
    licenses = [ "PSF" "ZPL" ];
  };    
}
