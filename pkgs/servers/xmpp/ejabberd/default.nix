{stdenv, fetchurl, expat, erlang, zlib, openssl, pam, lib}:

stdenv.mkDerivation rec {
  version = "2.1.13";
  name = "ejabberd-${version}";
  src = fetchurl {
    url = "http://www.process-one.net/downloads/ejabberd/${version}/${name}.tgz";
    sha256 = "0vf8mfrx7vr3c5h3nfp3qcgwf2kmzq20rjv1h9sk3nimwir1q3d8";
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
