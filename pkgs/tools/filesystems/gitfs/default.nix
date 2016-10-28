{ stdenv, fetchFromGitHub, python2Packages }:

python2Packages.buildPythonApplication rec {
  name = "gitfs-0.2.5";

  src = fetchFromGitHub {
    owner = "PressLabs";
    repo = "gitfs";
    rev = "495c6c52ec3573294ba7b8426ed794eb466cbb82";
    sha256 = "04yh6b5ivbviqy5k2768ag75cd5kr8k70ar0d801yvc8hnijvphk";
  };

  patchPhase = ''
    # requirement checks are unnecessary at runtime
    echo > requirements.txt
  '';

  buildInputs = with python2Packages; [ pytest pytestcov mock ];
  propagatedBuildInputs = with python2Packages; [ atomiclong fusepy pygit2 ];

  checkPhase = ''
    py.test
  '';

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
