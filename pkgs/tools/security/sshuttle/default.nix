{ lib
, stdenv
, python3Packages
, makeWrapper
, coreutils
, iptables
, nettools
, openssh
, procps
}:

python3Packages.buildPythonApplication rec {
  pname = "sshuttle";
  version = "1.1.1";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-9aPtHlqxITx6bfhgr0HxqQOrLK+/73Hzcazc/yHmnuY=";
  };

  patches = [ ./sudo.patch ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace '--cov=sshuttle --cov-branch --cov-report=term-missing' ""
  '';

  nativeBuildInputs = [ makeWrapper python3Packages.setuptools-scm ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  postInstall = ''
    wrapProgram $out/bin/sshuttle \
      --prefix PATH : "${lib.makeBinPath ([ coreutils openssh procps ] ++ lib.optionals stdenv.isLinux [ iptables nettools ])}" \
  '';

  meta = with lib; {
    homepage = "https://github.com/sshuttle/sshuttle/";
    description = "Transparent proxy server that works as a poor man's VPN";
    longDescription = ''
      Forward connections over SSH, without requiring administrator access to the
      target network (though it does require Python 2.7, Python 3.5 or later at both ends).
      Works with Linux and Mac OS and supports DNS tunneling.
    '';
    license = licenses.lgpl21;
    maintainers = with maintainers; [ domenkozar carlosdagos SuperSandro2000 ];
  };
}
