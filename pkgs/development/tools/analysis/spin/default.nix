{stdenv, fetchurl, yacc }:

stdenv.mkDerivation rec {
  version = "6.3.2";
  name = "spin-${version}";

  src = fetchurl {
    url = http://spinroot.com/spin/Src/spin632.tar.gz;
    curlOpts = "--user-agent 'Mozilla/5.0'";
    sha256 = "1llsv1mnwr99hvsm052i3wwpa3dm5j12s5p10hizi6i9hlp00b5y";
  };

  buildInputs = [ yacc ];

  sourceRoot = "Spin/Src${version}";

  installPhase = "install -D spin $out/bin/spin";

  meta = {
    description = "Formal verification tool for distributed software systems";
    homepage = http://spinroot.com/;
    license = "free";
    maintainers = stdenv.lib.maintainers.mornfall;
  };
}
