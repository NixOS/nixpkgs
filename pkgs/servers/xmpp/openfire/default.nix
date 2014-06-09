{ stdenv, fetchurl, builderDefs, jre }:

with builderDefs;
  let 
    version="3_6_3";
    localDefs = builderDefs.passthru.function (rec {
    src = /* put a fetchurl here */
      fetchurl {
        url = "http://www.igniterealtime.org/downloadServlet?filename=openfire/openfire_${version}.tar.gz";
        sha256 = "0ibzhmh9qw4lmx45ir1i280p30npgwnj7vrkl432kj3zi7hp79q2";
      };

    buildInputs = [jre];
    configureFlags = [];

    installPhase = fullDepEntry (''
      sed -e 's@\(common_jvm_locations\)=.*@\1${jre}@' -i bin/openfire
      cp -r . $out
      rm -r $out/logs
      mv $out/conf $out/conf.inst
      ln -s /var/log/openfire $out/logs
      ln -s /etc/openfire $out/conf
    '') 
    ["minInit" "doUnpack" "addInputs"];
  });
  in with localDefs;
stdenv.mkDerivation rec {
  name = "openfire-"+version;
  builder = writeScript (name + "-builder")
    (textClosure localDefs 
      [ installPhase doForceShare doPropagate]);
  meta = {
    description = "XMPP server in Java";
  };
}
