args : with args; 
rec {
  src = fetchurl {
    url = http://downloads.sourceforge.net/cheetahtemplate/Cheetah-2.0.1.tar.gz;
    sha256 = "134k4s5f116k23vb7wf9bynlx3gf0wwl7y0zp9ciz0q66nh1idkh";
  };

  buildInputs = [python makeWrapper];
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["installPythonPackage" (makeManyWrappers ''$out/bin/*'' ''--prefix PYTHONPATH : $(toPythonPath $out)'')];
      
  name = "cheetah-template-2.0.1";
  meta = {
    description = "Templating engine";
  };
}
