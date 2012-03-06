a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "0.4" a; 
  buildInputs = with a; [
    xmpppy pythonIRClib python makeWrapper
  ];
in
rec {
  src = fetchurl {
    url = "http://prdownloads.sourceforge.net/sourceforge/xmpppy/irc-transport-${version}.tar.gz";
    sha256 = "0gbc0dvj1p3088b6x315yjrlwnc5vvzp0var36wlf9z60ghvk8yb";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["deploy" (a.makeManyWrappers "$out/share/${name}/irc.py" a.pythonWrapperArguments)];
  deploy = a.fullDepEntry (''
    mkdir -p $out/bin $out/share/${name}
    sed -e 's@/usr/bin/@${a.python}/bin/@' -i irc.py
    sed -e '/configFiles/aconfigFiles += [os.getenv("HOME")+"/.pyIRCt.xml"]' -i config.py
    sed -e '/configFiles/aconfigFiles += [os.getenv("HOME")+"/.python-irc-transport.xml"]' -i config.py
    sed -e '/configFiles/iimport os' -i config.py
    cp * $out/share/$name
    echo "#! /bin/sh" > $out/bin/pyIRCt
    echo "cd $out/share/${name}" >> $out/bin/pyIRCt
    echo "./irc.py \"$@\"" >> $out/bin/pyIRCt
    chmod a+rx  $out/bin/pyIRCt $out/share/${name}/irc.py
  '') ["minInit" "addInputs" "doUnpack" "defEnsureDir"];
      
  name = "pyIRCt-" + version;
  meta = {
    description = "IRC transport module for XMPP";
  };
}
