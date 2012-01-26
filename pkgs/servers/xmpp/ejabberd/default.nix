{stdenv, fetchurl, expat, erlang, zlib, openssl, pam, lib}:

stdenv.mkDerivation rec {
  version = "2.1.10";
  name = "ejabberd-2.1.10";
  src = fetchurl {
    url = http://www.process-one.net/downloads/ejabberd/2.1.10/ejabberd-2.1.10.tar.gz;
    sha256 = "1gijv6d90w9fq0as2l0mp0fn65jihgd86nxry98pv6liks4fbhlx";
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
