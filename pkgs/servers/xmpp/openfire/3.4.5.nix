args : with args; with builderDefs;
  let localDefs = builderDefs.meta.function (rec {
    src = /* put a fetchurl here */
    fetchurl {
      url = http://www.igniterealtime.org/downloadServlet?filename=openfire/openfire_3_4_5.tar.gz;
      sha256 = "0j1ddk0wiqxhbi3872vf2mqx0jynswrvbfbabrp73zqhz3mdvsal";
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
  });
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
