{ stdenv, fetchFromGitHub, makeWrapper, pandoc
, coreutils, iptables, nettools, openssh, procps,  python }:
  
let version = "0.71"; in
stdenv.mkDerivation rec {
  name = "sshuttle-${version}";

  src = fetchFromGitHub {
    sha256 = "0yr8nih97jg6azfj3k7064lfbh3g36l6vwyjlngl4ph6mgcki1cm";
    rev = name;
    repo = "sshuttle";
    owner = "sshuttle";
  };

  nativeBuildInputs = [ makeWrapper pandoc ];
  buildInputs = [ coreutils iptables nettools openssh procps python ];

  preConfigure = ''
    cd src
  '';

  installPhase = ''
    mkdir -p $out/share/sshuttle
    cp -R sshuttle *.py compat $out/share/sshuttle

    mkdir -p $out/bin
    ln -s $out/share/sshuttle/sshuttle $out/bin
    wrapProgram $out/bin/sshuttle --prefix PATH : \
      "${stdenv.lib.concatStringsSep ":" (map (x: "${x}/bin") buildInputs)}"

    install -Dm644 sshuttle.8 $out/share/man/man8/sshuttle.8
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
