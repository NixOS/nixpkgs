{ stdenv, fetchurl, javac, jvm, junit }:

let version = "1.7.1"; in

/* TODO: Once we have Icedtea, use this Nix expression to build Ant with
   Sun's javac.  */

stdenv.mkDerivation {
  name = "ant-gcj-${version}";

  src = fetchurl {
    url = "mirror://apache/ant/source/apache-ant-${version}-src.tar.bz2";
    sha256 = "19pvqvgkxgpgsqm4lvbki5sm0z84kxmykdqicvfad47gc1r9mi2d";
  };

  patches = [ ./use-gcj.patch ];

  buildInputs = [ javac jvm junit ];

  configurePhase = ''
    mkdir -p "tool-aliases/bin"
    cd "tool-aliases/bin"
    cat > javac <<EOF
#!/bin/sh
opts="-C"
echo 'running \`gcj '"\$opts \$@'..."
exec "$(type -P gcj)" \$opts \$@
EOF
    chmod +x javac
    ln -sv $(type -P gij) java
    export PATH="$PWD:$PATH"

    cd ../..
    export JAVA_HOME="$PWD/tool-aliases"

    # Make JUnit visible.
    export CLASSPATH="$(find ${junit} -name \*.jar -printf "%p:")"
  '';

  # Note: We don't build the javadoc.
  buildPhase = ''
    ensureDir "$out"
    ./build.sh -Dant.install="$out" install-lite
  '';

  installPhase = ''
    # Actually, everything is already installed at this point, so we just
    # rearrange a few things.
    rm -v "$out/bin/"*.bat

    ensureDir "$out/lib/java"
    mv -v "$out/lib/"*.jar "$out/lib/java"
    sed -i "$out/bin/ant" \
        -e "s|^ANT_LIB=.*$|ANT_LIB=$out/lib/java|g ;
            s|JAVACMD=java.*$|JAVACMD=$(type -P gij)|g ;
            /^ant_exec_command/i export ANT_HOME=$out"
  '';

  meta = {
    description = "Apache Ant, a Java-based build tool";

    longDescription = ''
      Apache Ant is a Java-based build tool.  In theory, it is kind of like
      Make, but without Make's wrinkles.

      Why another build tool when there is already make, gnumake, nmake, jam,
      and others? Because all those tools have limitations that Ant's
      original author couldn't live with when developing software across
      multiple platforms.  Make-like tools are inherently shell-based -- they
      evaluate a set of dependencies, then execute commands not unlike what
      you would issue in a shell.  This means that you can easily extend
      these tools by using or writing any program for the OS that you are
      working on.  However, this also means that you limit yourself to the
      OS, or at least the OS type such as Unix, that you are working on.

      Ant is different.  Instead of a model where it is extended with
      shell-based commands, Ant is extended using Java classes.  Instead of
      writing shell commands, the configuration files are XML-based, calling
      out a target tree where various tasks get executed.  Each task is run
      by an object that implements a particular Task interface.
    '';

    homepage = http://ant.apache.org/;

    license = "Apache-2.0";

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
