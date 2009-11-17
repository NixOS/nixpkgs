{stdenv, fetchurl, expat, erlang, zlib, openssl, pam, lib}:

stdenv.mkDerivation rec {
  name = "ejabberd-2.1.0";
  src = fetchurl {
    url = http://www.process-one.net/downloads/ejabberd/2.1.0/ejabberd-2.1.0.tar.gz;
    sha256 = "16gn5ag3zyv578bqbz134l13cy1gl1xfa5y7dnqxgpr9gkdyrp5q";
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
