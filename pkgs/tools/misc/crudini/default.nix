{ stdenv, fetchFromGitHub, python2Packages }:

python2Packages.buildPythonApplication rec {
  name = "crudini-${version}";
  version = "0.9";

  src = fetchFromGitHub {
    owner  = "pixelb";
    repo   = "crudini";
    rev    = version;
    sha256 = "0x9z9lsygripj88gadag398pc9zky23m16wmh8vbgw7ld1nhkiav";
  };

  propagatedBuildInputs = with python2Packages; [ iniparse ];

  checkPhase = ''
    patchShebangs .
    pushd tests >/dev/null
    ./test.sh
  '';

  meta = with stdenv.lib; {
    description = "A utility for manipulating ini files ";
    homepage = http://www.pixelbeat.org/programs/crudini/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
