{ stdenv, fetchFromGitHub, python2Packages, help2man }:

python2Packages.buildPythonApplication rec {
  name = "crudini-${version}";
  version = "0.9";

  src = fetchFromGitHub {
    owner  = "pixelb";
    repo   = "crudini";
    rev    = version;
    sha256 = "0x9z9lsygripj88gadag398pc9zky23m16wmh8vbgw7ld1nhkiav";
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
