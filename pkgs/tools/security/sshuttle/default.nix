{ lib
, stdenv
, python3Packages
<<<<<<< HEAD
, fetchPypi
, installShellFiles
, makeWrapper
, sphinx
=======
, makeWrapper
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, coreutils
, iptables
, nettools
, openssh
, procps
}:

python3Packages.buildPythonApplication rec {
  pname = "sshuttle";
  version = "1.1.1";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3Packages.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit pname version;
    sha256 = "sha256-9aPtHlqxITx6bfhgr0HxqQOrLK+/73Hzcazc/yHmnuY=";
  };

  patches = [ ./sudo.patch ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace '--cov=sshuttle --cov-branch --cov-report=term-missing' ""
  '';

<<<<<<< HEAD
  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    python3Packages.setuptools-scm
    sphinx
  ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  postBuild = ''
    make man -C docs
  '';

  postInstall = ''
    installManPage docs/_build/man/*

=======
  nativeBuildInputs = [ makeWrapper python3Packages.setuptools-scm ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  postInstall = ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    wrapProgram $out/bin/sshuttle \
      --prefix PATH : "${lib.makeBinPath ([ coreutils openssh procps ] ++ lib.optionals stdenv.isLinux [ iptables nettools ])}" \
  '';

  meta = with lib; {
<<<<<<< HEAD
=======
    homepage = "https://github.com/sshuttle/sshuttle/";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    description = "Transparent proxy server that works as a poor man's VPN";
    longDescription = ''
      Forward connections over SSH, without requiring administrator access to the
      target network (though it does require Python 2.7, Python 3.5 or later at both ends).
      Works with Linux and Mac OS and supports DNS tunneling.
    '';
<<<<<<< HEAD
    homepage = "https://github.com/sshuttle/sshuttle";
    changelog = "https://github.com/sshuttle/sshuttle/blob/v${version}/CHANGES.rst";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ domenkozar carlosdagos ];
=======
    license = licenses.lgpl21;
    maintainers = with maintainers; [ domenkozar carlosdagos SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
