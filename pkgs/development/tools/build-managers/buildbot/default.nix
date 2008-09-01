{stdenv, fetchurl, python, twisted, makeWrapper}:

stdenv.mkDerivation rec {
  name = "buildbot-${version}";
  version = "0.7.8";
  meta = {
    homepage = "http://buildbot.net/";
    description = "A system to automate the compile/test cycle to validate code changes.";
  };
  src = fetchurl {
    url = "mirror://sourceforge/buildbot/buildbot-${version}.tar.gz";
    sha256 = "0f3qkbs1y4a1djxbfkvsr1639qkc7bzzsz2wpas2mk1zg8zrci2v";
  };
  propagatedBuildInputs = [python twisted makeWrapper];
  buildPhase = "true";
  installPhase =
  ''
     python setup.py install --prefix=$out --install-lib=$(toPythonPath $out) -O1
     for n in $out/bin/*; do wrapProgram $n --set PYTHONPATH "$(toPythonPath $out):$PYTHONPATH"; done
  '';
}
