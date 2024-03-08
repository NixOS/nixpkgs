{ lib, fetchFromGitHub, python3Packages }:

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

    # NOTE: As of gitfs 0.5.2, The pygit2 release that upstream uses is a major
    # version behind the one packaged in nixpkgs.
    substituteInPlace gitfs/mounter.py --replace \
      'from pygit2.remote import RemoteCallbacks' \
      'from pygit2 import RemoteCallbacks'
  '';

  nativeCheckInputs = with python3Packages; [ pytest pytest-cov mock ];
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
    homepage = "https://github.com/PressLabs/gitfs";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.robbinch ];
    mainProgram = "gitfs";
  };
}
