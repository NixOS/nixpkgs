{stdenv, fetchFromGitHub, python, buildPythonPackage, numpy, matplotlib}:

buildPythonPackage rec {
  pname = "scitools";
  version = "0.9.0";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "hplgit";
    repo = "scitools";
    rev = "${name}";
    sha256 = "07yxbc7spr7vy72lg3czv4r4q2f0wq17vszlnsfmsb2ix8jajp4d";
  };

  buildInputs = [ matplotlib ];
  propagatedBuildInputs = [ numpy ];

  meta = {
    description = "Python library for scientific computing";
    homepage = https://github.com/hplgit/scitools;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ jamtrott ];
  };
}
