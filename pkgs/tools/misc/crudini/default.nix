{ stdenv, fetchFromGitHub, python2Packages, help2man }:

python2Packages.buildPythonApplication rec {
  pname = "crudini";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner  = "pixelb";
    repo   = "crudini";
    rev    = version;
    sha256 = "0298hvg0fpk0m0bjpwryj3icksbckwqqsr9w1ain55wf5s0v24k3";
  };

  nativeBuildInputs = [ help2man ];
  propagatedBuildInputs = with python2Packages; [ iniparse ];

  doCheck = true;

  prePatch = ''
    # make runs the unpatched version in src so we need to patch them in addition to tests
    patchShebangs .
  '';

  postBuild = ''
    make all
  '';

  postInstall = ''
    mkdir -p $out/share/{man/man1,doc/crudini}

    cp README EXAMPLES $out/share/doc/crudini/
    for f in *.1 ; do
      gzip -c $f > $out/share/man/man1/$(basename $f).gz
    done
  '';

  checkPhase = ''
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
