{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "findbugs-3.0.0";

  src = fetchurl {
    url = mirror://sourceforge/findbugs/findbugs-3.0.0.tar.gz;
    sha256 = "0csz6drzdz867r2p2wa4cvick6bv9dpz2yym9wrvp3fnxabmgiri";
  };

  buildPhase = ''
    substituteInPlace bin/findbugs --replace /bin/pwd pwd
  '';

  installPhase = ''
    d=$out/libexec/findbugs
    mkdir -p $d $out/bin $out/nix-support

    cp -prd bin lib plugin doc $d/
    rm $d/bin/*.bat
    for i in $d/bin/*; do
      if [ -f $i ]; then ln -s $i $out/bin/; fi
    done

    # Get rid of unnecessary JARs.
    rm $d/lib/ant.jar

    # Make some JARs findable.
    mkdir -p $out/share/java
    ln -s $d/lib/{findbugs.jar,findbugs-ant.jar} $out/share/java/

    cat <<EOF > $out/nix-support/setup-hook
    export FINDBUGS_HOME=$d
    EOF
  '';

  meta = {
    description = "A static analysis tool to find bugs in Java programs automatically";
    homepage = http://findbugs.sourceforge.net/;
  };
}
