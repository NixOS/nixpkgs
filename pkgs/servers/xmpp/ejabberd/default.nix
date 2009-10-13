{stdenv, fetchurl, fetchsvn, expat, erlang, zlib, openssl, pam}:

stdenv.mkDerivation rec {
  name = "ejabberd-2.0.5";
  #src = fetchurl {
  #  url = http://www.process-one.net/downloads/ejabberd/2.0.5/ejabberd-2.0.5.tar.gz;
  #  sha256 = "130rjl93l54c7p4glsfn3j7xwpwdyinhj6pp1di3mdx2mzi91vrp";
  #};
  src = fetchsvn {
    url = http://svn.process-one.net/ejabberd/trunk;
    rev = "2666";
    sha256 = "c927ddc08c9cd748db93f48bcae96f9bd1c36e1ce107c9b4774e5423574ab7cb";
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
