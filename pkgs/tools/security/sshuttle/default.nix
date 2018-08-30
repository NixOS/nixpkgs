{ stdenv, python3Packages, fetchurl, makeWrapper, pandoc
, coreutils, iptables, nettools, openssh, procps, fetchpatch }:

python3Packages.buildPythonApplication rec {
  name = "sshuttle-${version}";
  version = "0.78.4";

  src = fetchurl {
    sha256 = "0pqk43kd7crqhg6qgnl8kapncwgw1xgaf02zarzypcw64kvdih9h";
    url = "mirror://pypi/s/sshuttle/${name}.tar.gz";
  };

  patches = [ ./sudo.patch ];

  nativeBuildInputs = [ makeWrapper python3Packages.setuptools_scm ] ++ stdenv.lib.optional (stdenv.system != "i686-linux") pandoc;
  buildInputs =
    [ coreutils openssh procps nettools ]
    ++ stdenv.lib.optionals stdenv.isLinux [ iptables ];

  checkInputs = with python3Packages; [ mock pytest pytestrunner ];

  postInstall = let
    mapPath = f: x: stdenv.lib.concatStringsSep ":" (map f x);
  in ''
  wrapProgram $out/bin/sshuttle \
    --prefix PATH : "${mapPath (x: "${x}/bin") buildInputs}" \
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/sshuttle/sshuttle/;
    description = "Transparent proxy server that works as a poor man's VPN";
    longDescription = ''
      Forward connections over SSH, without requiring administrator access to the
      target network (though it does require Python 2 at both ends).
      Works with Linux and Mac OS and supports DNS tunneling.
    '';
    license = licenses.gpl2;
    maintainers = with maintainers; [ domenkozar ];
    platforms = platforms.unix;
  };
}
