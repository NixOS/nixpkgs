{ stdenv, pythonPackages, fetchurl, makeWrapper, pandoc
, coreutils, iptables, nettools, openssh, procps }:
  
pythonPackages.buildPythonApplication rec {
  name = "sshuttle-${version}";
  version = "0.77.2";

  src = fetchurl {
    sha256 = "1fwlhr5r9pl3pns65nn4mxf5ivypmd2a12gv3vpyznfy5f097k10";
    url = "https://pypi.python.org/packages/source/s/sshuttle/${name}.tar.gz";
  };

  patches = [ ./sudo.patch ];

  propagatedBuildInputs = with pythonPackages; [ PyXAPI mock pytest ];
  nativeBuildInputs = [ makeWrapper pandoc pythonPackages.setuptools_scm ];
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
    homepage = https://github.com/sshuttle/sshuttle/;
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
