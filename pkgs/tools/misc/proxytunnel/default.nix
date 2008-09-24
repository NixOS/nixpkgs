args:
args.stdenv.mkDerivation {
  name = "proxytunnel-1.9.0";

  src = args.fetchurl {
    url = mirror://sourceforge/proxytunnel/proxytunnel-1.9.0.tgz;
    sha256 = "1fd644kldsg14czkqjybqh3wrzwsp3dcargqf4fjkpqxv3wbpx9f";
  };

  buildInputs =(with args; [openssl]);

  installPhase=''make DESTDIR="$out" PREFIX="" install'';

  meta = {
      description = "program that connects stdin and stdout to a server somewhere on the network, through a standard HTTPS proxy";
      homepage = http://proxytunnel.sourceforge.net/download.php;
      license = "GPLv2";
  };
}
