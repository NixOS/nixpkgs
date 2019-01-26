{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "findbugs-3.0.1";

  src = fetchurl {
    url = "mirror://sourceforge/findbugs/${name}.tar.gz";
    sha256 = "06b46fz4nid7qvm36r66zw01fr87y4jyz21ixw27b8hkqah0s3p8";
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

  meta = with stdenv.lib; {
    description = "A static analysis tool to find bugs in Java programs automatically";
    homepage = http://findbugs.sourceforge.net/;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; unix;
    license = licenses.lgpl3;
  };
}
