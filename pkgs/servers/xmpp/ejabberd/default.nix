{stdenv, fetchurl, fetchsvn, expat, erlang, zlib, openssl, pam}:

stdenv.mkDerivation rec {
  name = "ejabberd-2.0.5";
  #src = fetchurl {
  #  url = http://www.process-one.net/downloads/ejabberd/2.0.5/ejabberd-2.0.5.tar.gz;
  #  sha256 = "130rjl93l54c7p4glsfn3j7xwpwdyinhj6pp1di3mdx2mzi91vrp";
  #};
  src = fetchsvn {
    url = http://svn.process-one.net/ejabberd/trunk;
    rev = "r22196";
    sha256 = "6a9a3e6962e95feffccce2f67485da6e8d92b0cf904bc96fc259c5d0cc4b7659";
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
  };
}
