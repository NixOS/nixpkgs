{ stdenv, python, xmpppy, pythonPackages, fetchcvs } :

stdenv.mkDerivation rec {
  name = "pyMAILt-${version}";
  version = "20090101";

  src = fetchcvs {
		cvsRoot = ":pserver:anonymous@xmpppy.cvs.sourceforge.net:/cvsroot/xmpppy";
		module = "xmpppy/mail-transport";
		date = "2009-01-01";
		sha256 = "15301252e52b4ccb2156baefed8982a2a0cce3ae8eae3caf3cc28dfa615c8d6e";
	};

  pythonPath = [ xmpppy ];
  buildInputs = [ pythonPackages.wrapPython ];

  /* doConfigure should be removed if not needed */
  installPhase = ''
    cd mail-transport
    mkdir -p $out/bin $out/share/${name}
    sed -e 's@/usr/bin/@${python}/bin/@' -i mail.py
    sed -e '/configFiles/aconfigFiles += [os.getenv("HOME")+"/.pyMAILt.xml"]' -i config.py
    sed -e '/configFiles/aconfigFiles += [os.getenv("HOME")+"/.python-mail-transport.xml"]' -i config.py
    sed -e '/configFiles/iimport os' -i config.py
    cp * $out/share/$name
    cat > $out/bin/pyMAILt <<EOF
      #! /bin/sh
      cd $out/share/${name}
      ./mail.py \"$@\"
    EOF
    chmod a+rx  $out/bin/pyMAILt $out/share/${name}/mail.py
    wrapPythonPrograms
  '';

  meta = {
    description = "Email transport module for XMPP";
    platforms = stdenv.lib.platforms.unix;
  };
}
