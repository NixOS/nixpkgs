{ stdenv, pythonPackages, fetchFromGitHub, makeWrapper, pandoc
, coreutils, iptables, nettools, openssh, procps }:
  
pythonPackages.buildPythonPackage rec {
  version = "0.74";
  name = "sshuttle-${version}";

  src = fetchFromGitHub {
    sha256 = "1mx440wb1clis97nvgx67am9qssa3v11nb9irjzhnx44ygadhfcp";
    rev = "v${version}";
    repo = "sshuttle";
    owner = "sshuttle";
  };

  patches = [ ./sudo.patch ];

  propagatedBuildInputs = with pythonPackages; [ PyXAPI mock pytest ];
  nativeBuildInputs = [ makeWrapper pandoc ];
  buildInputs =
    [ coreutils openssh ] ++
    stdenv.lib.optionals stdenv.isLinux [ iptables nettools procps ];

  postInstall = let
    mapPath = f: x: stdenv.lib.concatStringsSep ":" (map f x);
  in ''
  wrapProgram $out/bin/sshuttle \
    --prefix PATH : "${mapPath (x: "${x}/bin") buildInputs}" \
  '';
  
  meta = with stdenv.lib; {
    inherit version;
    inherit (src.meta) homepage;
    description = "Transparent proxy server that works as a poor man's VPN";
    longDescription = ''
      Forward connections over SSH, without requiring administrator access to the
      target network (though it does require Python 2 at both ends).
      Works with Linux and Mac OS and supports DNS tunneling.
    '';
    maintainers = with maintainers; [ iElectric nckx ];
    platforms = platforms.unix;
  };
}
