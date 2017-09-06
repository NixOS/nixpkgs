{lib, fetchurl, python, buildPythonPackage, numpy, matplotlib}:

buildPythonPackage rec {
  pname = "scitools";
  version = "0.9.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/hplgit/scitools/archive/scitools-${version}.tar.gz";
    sha256 = "1aj3i56aim542krynza46plxbci7dfhq9rq7hwfw4946rjbm3klc";
  };

  buildInputs = [ matplotlib ];
  propagatedBuildInputs = [ numpy ];

  meta = {
    description = "Python library for scientific computing";
    homepage = https://github.com/hplgit/scitools;
  };
}
