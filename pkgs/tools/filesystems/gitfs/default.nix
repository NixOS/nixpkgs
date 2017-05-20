{ stdenv, fetchFromGitHub, python2Packages }:

python2Packages.buildPythonApplication rec {
  name = "gitfs-${version}";
  version = "0.4.5.1";

  src = fetchFromGitHub {
    owner = "PressLabs";
    repo = "gitfs";
    rev = version;
    sha256 = "1s9ml2ryqxvzzq9mxa9y3xmzr742qxcpw9kzzbr7vm3bxgkyi074";
  };

  patchPhase = ''
    # requirement checks are unnecessary at runtime
    echo > requirements.txt
  '';

  buildInputs = with python2Packages; [ pytest pytestcov mock ];
  propagatedBuildInputs = with python2Packages; [ atomiclong fusepy pygit2 ];

  checkPhase = "py.test";
  doCheck = false;

  meta = {
    description = "A FUSE filesystem that fully integrates with git";
    longDescription = ''
      A git remote repository's branch can be mounted locally,
      and any subsequent changes made to the files will be
      automatically committed to the remote.
    '';
    homepage = https://github.com/PressLabs/gitfs;
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.robbinch ];
  };
}
