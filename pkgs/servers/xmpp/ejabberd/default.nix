{stdenv, fetchurl, expat, erlang, zlib, openssl}:

stdenv.mkDerivation {
  name = "ejabberd-2.0.0";
  src = fetchurl {
    url = http://www.process-one.net/downloads/ejabberd/2.0.0/ejabberd-2.0.0.tar.gz;
    sha256 = "086e105cb402ef868e3187277db1486807e1b34a2e3e3679f0ee6de1e5fd2e54";
  };
  buildInputs = [ expat erlang zlib openssl ];
  patchPhase = ''
    sed -i -e "s|erl \\\|${erlang}/bin/erl \\\|" src/ejabberdctl.template
  '';
  preConfigure = ''
    cd src
  '';  
  
  meta = {
    description = "Open-source XMPP application server written in Erlang";
    license = "GPLv2";
    homepage = http://www.ejabberd.im;
  };
}
