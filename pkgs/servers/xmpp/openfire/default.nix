{ stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  name = "openfire-${version}";
  version  = "3_6_3";

  src = fetchurl {
    url = "http://www.igniterealtime.org/downloadServlet?filename=openfire/openfire_${version}.tar.gz";
    sha256 = "0ibzhmh9qw4lmx45ir1i280p30npgwnj7vrkl432kj3zi7hp79q2";
  };

  buildInputs = [ jre ];

  installPhase = ''
    sed -e 's@\(common_jvm_locations=\).*@\1${jre}@' -i bin/openfire
    cp -r . $out
    rm -r $out/logs
    mv $out/conf $out/conf.inst
    ln -s /var/log/openfire $out/logs
    ln -s /etc/openfire $out/conf
  ''; 

  meta = {
    description = "XMPP server in Java";
    platforms = stdenv.lib.platforms.unix;
  };
}
