{stdenv, fetchurl, expat, erlang, zlib, openssl, pam, lib}:

stdenv.mkDerivation rec {
  version = "2.1.4";
  name = "ejabberd-2.1.4";
  src = fetchurl {
    url = http://www.process-one.net/downloads/ejabberd/2.1.4/ejabberd-2.1.4.tar.gz;
    sha256 = "205ee09e38c57527cfa1a4be6ca664cec2e8c6b40eeffaac008735fcdc5e7527";
  };
  buildInputs = [ expat erlang zlib openssl pam ];
  patchPhase = ''
    sed -i -e "s|erl \\\|${erlang}/bin/erl \\\|" src/ejabberdctl.template
  '';
  preConfigure = ''
    cd src
  '';  
  configureFlags = ["--enable-pam"];
  
  meta = {
    description = "Open-source XMPP application server written in Erlang";
    license = "GPLv2";
    homepage = http://www.ejabberd.im;
    maintainers = [ lib.maintainers.sander ];
  };
}
