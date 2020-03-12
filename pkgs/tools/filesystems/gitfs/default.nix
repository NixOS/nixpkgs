{ stdenv, fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "gitfs";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "PressLabs";
    repo = "gitfs";
    rev = version;
    sha256 = "1jzwdwan8ndvp2lw6j7zbvg5k9rgf2d8dcxjrwc6bwyk59xdxn4p";
  };

  patchPhase = ''
    # requirement checks are unnecessary at runtime
    echo > requirements.txt
  '';

  checkInputs = with python3Packages; [ pytest pytestcov mock ];
  propagatedBuildInputs = with python3Packages; [ atomiclong fusepy pygit2 six ];

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
