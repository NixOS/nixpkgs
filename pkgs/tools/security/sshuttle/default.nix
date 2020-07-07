{ stdenv, python3Packages, fetchurl, makeWrapper
, coreutils, iptables, nettools, openssh, procps }:

python3Packages.buildPythonApplication rec {
  pname = "sshuttle";
  version = "1.0.2";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "02c3r27alch7dfy39v40n9g7mccsrj5hwnb1s0gkw4iwxkx2lzg1";
  };

  patches = [ ./sudo.patch ];

  nativeBuildInputs = [ makeWrapper python3Packages.setuptools_scm ];
  buildInputs =
    [ coreutils openssh procps nettools ]
    ++ stdenv.lib.optionals stdenv.isLinux [ iptables ];

  checkInputs = with python3Packages; [ mock pytest pytestcov pytestrunner flake8 ];

  postInstall = let
    mapPath = f: x: stdenv.lib.concatStringsSep ":" (map f x);
  in ''
  wrapProgram $out/bin/sshuttle \
    --prefix PATH : "${mapPath (x: "${x}/bin") buildInputs}" \
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/sshuttle/sshuttle/";
    description = "Transparent proxy server that works as a poor man's VPN";
    longDescription = ''
      Forward connections over SSH, without requiring administrator access to the
      target network (though it does require Python 2.7, Python 3.5 or later at both ends).
      Works with Linux and Mac OS and supports DNS tunneling.
    '';
    license = licenses.gpl2;
    maintainers = with maintainers; [ domenkozar carlosdagos ];
    platforms = platforms.unix;
  };
}
