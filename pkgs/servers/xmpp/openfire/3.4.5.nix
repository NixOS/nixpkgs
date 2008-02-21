args : with args; with builderDefs {src="";} null;
  let localDefs = builderDefs (rec {
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
    '') 
    ["minInit" "doUnpack" "findInputs"];
  }) null; /* null is a terminator for sumArgs */
  in with localDefs;
stdenv.mkDerivation rec {
  name = "openfire-"+version;
  builder = writeScript (name + "-builder")
    (textClosure localDefs 
      [ doForceShare doPropagate installPhase]);
  meta = {
    description = "
    XMPP server in Java.
";
  };
}
