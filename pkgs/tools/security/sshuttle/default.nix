{ lib
, stdenv
, python3Packages
, fetchFromGitHub
, installShellFiles
, makeWrapper
, sphinx
, coreutils
, iptables
, nettools
, openssh
, procps
}:

python3Packages.buildPythonApplication rec {
  pname = "sshuttle";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "sshuttle";
    repo = "sshuttle";
    rev = "v${version}";
    hash = "sha256-7jiDTjtL4FiQ4GimSPtUDKPUA29l22a7XILN/s4/DQY=";
  };

  patches = [ ./sudo.patch ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace '--cov=sshuttle --cov-branch --cov-report=term-missing' ""
  '';

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

    wrapProgram $out/bin/sshuttle \
      --prefix PATH : "${lib.makeBinPath ([ coreutils openssh procps ] ++ lib.optionals stdenv.isLinux [ iptables nettools ])}" \
  '';

  meta = with lib; {
    description = "Transparent proxy server that works as a poor man's VPN";
    mainProgram = "sshuttle";
    longDescription = ''
      Forward connections over SSH, without requiring administrator access to the
      target network (though it does require Python 2.7, Python 3.5 or later at both ends).
      Works with Linux and Mac OS and supports DNS tunneling.
    '';
    homepage = "https://github.com/sshuttle/sshuttle";
    changelog = "https://github.com/sshuttle/sshuttle/blob/v${version}/CHANGES.rst";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ domenkozar carlosdagos ];
  };
}
