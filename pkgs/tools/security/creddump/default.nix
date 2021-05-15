{ lib, fetchFromGitLab, python2, python2Packages }:

python2Packages.buildPythonApplication rec {
  pname = "creddump";
  version = "0.3";

  src = fetchFromGitLab {
    owner = "kalilinux";
    repo = "packages/creddump";
    rev = "debian/${version}-1kali2";
    sha256 = "0r3rs2hggsvv619l3fh3c0jli6d3ryyj30ni3hz0nz670z5smzcf";
  };

  # No setup.py is available
  dontBuild = true;
  doCheck = false;
  propagatedBuildInputs = [ python2Packages.pycrypto ];

  installPhase = ''
    mkdir -p ${placeholder "out"}/bin
    cp -r framework ${placeholder "out"}/bin/framework
    cp pwdump.py ${placeholder "out"}/bin/pwdump
    cp cachedump.py ${placeholder "out"}/bin/cachedump
    cp lsadump.py ${placeholder "out"}/bin/lsadump
  '';

  meta = with lib; {
    description = "Python tool to extract various credentials and secrets from Windows registry hives";
    homepage = "https://gitlab.com/kalilinux/packages/creddump";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.fishi0x01 ];
  };
}

