args:
args.stdenv.mkDerivation {
  name = "ircd-hybrid-7.2.2";

  src = args.fetchurl {
    url = http://prdownloads.sourceforge.net/ircd-hybrid/ircd-hybrid-7.2.2.tgz;
    sha256 = "1xn4dfbgx019mhismfnr2idhslvarlajyahj7c6bqzmarcwwrvck";
  };

  buildInputs =(with args; [openssl zlib]);

  configureFlags = (with args; ["--with-nicklen=100" 
	"--with-topiclen=360" 
	("--enable-openssl=" + openssl)]);

  preInstall = "mkdir -p \${out}/ ; ln -s /home/ircd \${out}/logs;";

  meta = {
    description = "
	An IPv6-capable IRC server.
";
  };
}
