a :  
let 
  fetchurl = a.fetchurl;

  buildInputs = with a; [
    xmpppy python makeWrapper
  ];
in
rec {
  src = a.fetchcvs {
		cvsRoot = ":pserver:anonymous@xmpppy.cvs.sourceforge.net:/cvsroot/xmpppy";
		module = "xmpppy/mail-transport";
		date = "2009-01-01";
		sha256 = "15301252e52b4ccb2156baefed8982a2a0cce3ae8eae3caf3cc28dfa615c8d6e";
	};

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["deploy" (a.makeManyWrappers "$out/share/${name}/mail.py" a.pythonWrapperArguments)];
  deploy = a.fullDepEntry (''
    cd mail-transport
    mkdir -p $out/bin $out/share/${name}
    sed -e 's@/usr/bin/@${a.python}/bin/@' -i mail.py
    sed -e '/configFiles/aconfigFiles += [os.getenv("HOME")+"/.pyMAILt.xml"]' -i config.py
    sed -e '/configFiles/aconfigFiles += [os.getenv("HOME")+"/.python-mail-transport.xml"]' -i config.py
    sed -e '/configFiles/iimport os' -i config.py
    cp * $out/share/$name
    echo "#! /bin/sh" > $out/bin/pyMAILt
    echo "cd $out/share/${name}" >> $out/bin/pyMAILt
    echo "./mail.py \"$@\"" >> $out/bin/pyMAILt
    chmod a+rx  $out/bin/pyMAILt $out/share/${name}/mail.py
  '') ["minInit" "addInputs" "doUnpack" "defEnsureDir"];
      
  name = "pyMAILt";
  meta = {
    description = "Email transport module for XMPP";
  };
}
