{ stdenv, fetchFromGitHub, proot, patchelf, fakechroot, runc, simplejson, pycurl, coreutils, nose, mock, buildPythonApplication }:

buildPythonApplication rec {

  version = "1.1.3";
  pname = "udocker";

  src = fetchFromGitHub {
    owner = "indigo-dc";
    repo = "udocker" ;
    rev = "v${version}";
    sha256 = "1c8y1p3brj987drikwrby8m1hdr40ja4anx0p4xsij3ll2h62w6z";
  };

  buildInputs = [ proot patchelf fakechroot runc simplejson pycurl coreutils ];

  postPatch = ''
      substituteInPlace udocker.py --replace /usr/sbin:/sbin:/usr/bin:/bin $PATH
      substituteInPlace udocker.py --replace /bin/chmod ${coreutils}/bin/chmod
      substituteInPlace udocker.py --replace /bin/rm ${coreutils}/bin/rm
      substituteInPlace tests/unit_tests.py --replace /bin/rm ${coreutils}/bin/rm
      substituteInPlace udocker.py --replace "autoinstall = True" "autoinstall = False"
  '';

  checkInputs = [
    nose
    mock
  ];

  checkPhase = ''
    NOSE_EXCLUDE=test_03_create_repo,test_04_is_repo,test_02__get_group_from_host nosetests -v tests/unit_tests.py
  '';

  meta = with stdenv.lib; {
    description = "basic user tool to execute simple docker containers in user space without root privileges";
    homepage = https://indigo-dc.gitbooks.io/udocker;
    license = licenses.asl20;
    maintainers = [ maintainers.bzizou ];
    platforms = platforms.linux;
  };

}
