{ stdenv, fetchurl, xmpppy, pythonIRClib, python, pythonPackages } :

stdenv.mkDerivation rec {
  name = "pyIRCt-${version}";
  version = "0.4";

  src = fetchurl {
    url = "mirror://sourceforge/xmpppy/irc-transport-${version}.tar.gz";
    sha256 = "0gbc0dvj1p3088b6x315yjrlwnc5vvzp0var36wlf9z60ghvk8yb";
  };

  buildInputs = [ pythonPackages.wrapPython ];

  pythonPath = [
    xmpppy pythonIRClib
  ];

  /* doConfigure should be removed if not needed */
  # phaseNames = ["deploy" (a.makeManyWrappers "$out/share/${name}/irc.py" a.pythonWrapperArguments)];

  installPhase = ''
    mkdir -p $out/bin $out/share/${name}
    sed -e 's@/usr/bin/@${python}/bin/@' -i irc.py
    sed -e '/configFiles/aconfigFiles += [os.getenv("HOME")+"/.pyIRCt.xml"]' -i config.py
    sed -e '/configFiles/aconfigFiles += [os.getenv("HOME")+"/.python-irc-transport.xml"]' -i config.py
    sed -e '/configFiles/iimport os' -i config.py
    cp * $out/share/${name}
    cat > $out/bin/pyIRCt <<EOF
      #! /bin/sh
      cd $out/share/${name}
      ./irc.py \"$@\"
    EOF
    chmod a+rx  $out/bin/pyIRCt $out/share/${name}/irc.py
    wrapPythonPrograms
  '';

  meta = {
    description = "IRC transport module for XMPP";
    platforms = stdenv.lib.platforms.unix;
  };
}
