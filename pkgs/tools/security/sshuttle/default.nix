{ stdenv, fetchurl, iptables, python, pythonPackages }:
  
stdenv.mkDerivation rec {
  name = "sshuttle-${version}";
  version = "0.61";

  src = fetchurl {
    url = "https://github.com/apenwarr/sshuttle/archive/sshuttle-0.61.tar.gz";
    sha256 = "1v2v1kbwnmx6ygzhbgqcmyafx914s2p7vjp7l0pf52sa7qkliy9b";
  };

  preBuild = ''
   substituteInPlace Documentation/all.do --replace "/bin/ls" "$(type -tP ls)";
   substituteInPlace Documentation/md2man.py --replace "/usr/bin/env python" "${python}/bin/python"
  '';

  phases = "unpackPhase installPhase";

  installPhase = ''
    mkdir -p $out/bin
    cp -R . $out
    ln -s $out/sshuttle $out/bin/sshuttle
  '';
  

  buildInputs = [ iptables python pythonPackages.markdown pythonPackages.beautifulsoup ];

  meta = with stdenv.lib; {
    homepage = https://github.com/apenwarr/sshuttle;
    description = "Transparent proxy server that works as a poor man's VPN";
    maintainers = with maintainers; [ iElectric ];
    platforms = platforms.unix;
  };
}
