args : with args; with builderDefs {src="";} null;
  let localDefs = builderDefs (rec {
    src = /* put a fetchurl here */
    fetchurl {
      url = http://www.igniterealtime.org/downloadServlet?filename=openfire/openfire_3_5_2.tar.gz;
      sha256 = "13xzwl8kc8i8xgdv7fpwgkj1wjhzagx4b03fkkj2hcfgdkp1978q";
    };

    buildInputs = [jre];
    configureFlags = [];

    installPhase = FullDepEntry (''
      sed -e 's@\(common_jvm_locations\)=.*@\1${jre}@' -i bin/openfire
      cp -r . $out
      rm -r $out/logs
      mv $out/conf $out/conf.inst
      ln -s /var/log/openfire $out/logs
      ln -s /etc/openfire $out/conf
    '') 
    ["minInit" "doUnpack" "addInputs"];
  }) null; /* null is a terminator for sumArgs */
  in with localDefs;
stdenv.mkDerivation rec {
  name = "openfire-"+version;
  builder = writeScript (name + "-builder")
    (textClosure localDefs 
      [ installPhase doForceShare doPropagate]);
  meta = {
    description = "
    XMPP server in Java.
";
		inherit src;
  };
}
