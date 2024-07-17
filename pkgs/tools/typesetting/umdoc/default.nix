{ 
  stdenv,
  cmake,
  texliveFull
  }:

stdenv.mkDerivation {
  name = "umdoc";
  version = "0.3.0-1";
  src = fetchGit {
	url = "https://github.com/craflin/umdoc.git";
   	ref = "master";
        submodules = true;
  };

  postPatch = ''
     sed -i -e 's$include(CDeploy)$$' CMakeLists.txt
     head -n 42 CMakeLists.txt > tmp.txt
     mv tmp.txt CMakeLists.txt
     export HOME=$(pwd)
  '';
  buildPhase =''
  '';

  buildInputs = [ cmake texliveFull ];

}
