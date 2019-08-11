{ fetchurl, stdenv, coreutils, makeWrapper }:

let version = "1.10.2"; in

stdenv.mkDerivation {
  name = "ant-${version}";

  buildInputs = [ makeWrapper ];

  src = fetchurl {
    url = "mirror://apache/ant/binaries/apache-ant-${version}-bin.tar.bz2";
    sha256 = "0662qammjvibh9kgkxzadkayfn2r7iwnagbwaw28crqqclrb2rp1";
  };

  contrib = fetchurl {
    url = mirror://sourceforge/ant-contrib/ant-contrib-1.0b3-bin.tar.bz2;
    sha256 = "96effcca2581c1ab42a4828c770b48d54852edf9e71cefc9ed2ffd6590571ad1";
  };

  installPhase =
    ''
      mkdir -p $out/bin $out/lib/ant
      mv * $out/lib/ant/

      # Get rid of the manual (35 MiB).  Maybe we should put this in a
      # separate output.  Keep the antRun script since it's vanilla sh
      # and needed for the <exec/> task (but since we set ANT_HOME to
      # a weird value, we have to move antRun to a weird location).
      # Get rid of the other Ant scripts since we provide our own.
      mv $out/lib/ant/bin/antRun $out/bin/
      rm -rf $out/lib/ant/{manual,bin,WHATSNEW}
      mkdir $out/lib/ant/bin
      mv $out/bin/antRun $out/lib/ant/bin/

      # Install ant-contrib.
      unpackFile $contrib
      cp -p ant-contrib/ant-contrib-*.jar $out/lib/ant/lib/

      cat >> $out/bin/ant <<EOF
      #! ${stdenv.shell} -e

      ANT_HOME=$out/lib/ant

      # Find the JDK by looking for javac.  As a fall-back, find the
      # JRE by looking for java.  The latter allows just the JRE to be
      # used with (say) ECJ as the compiler.  Finally, allow the GNU
      # JVM.
      if [ -z "\$JAVA_HOME" ]; then
          for i in javac java gij; do
              if p="\$(type -p \$i)"; then
                  export JAVA_HOME="\$(${coreutils}/bin/dirname \$(${coreutils}/bin/dirname \$(${coreutils}/bin/readlink -f \$p)))"
                  break
              fi
          done
          if [ -z "\$JAVA_HOME" ]; then
              echo "\$0: cannot find the JDK or JRE" >&2
              exit 1
          fi
      fi

      if [ -z \$NIX_JVM ]; then
          if [ -e \$JAVA_HOME/bin/java ]; then
              NIX_JVM=\$JAVA_HOME/bin/java
          elif [ -e \$JAVA_HOME/bin/gij ]; then
              NIX_JVM=\$JAVA_HOME/bin/gij
          else
              NIX_JVM=java
          fi
      fi

      LOCALCLASSPATH="\$ANT_HOME/lib/ant-launcher.jar\''${LOCALCLASSPATH:+:}\$LOCALCLASSPATH"

      exec \$NIX_JVM \$NIX_ANT_OPTS \$ANT_OPTS -classpath "\$LOCALCLASSPATH" \
          -Dant.home=\$ANT_HOME -Dant.library.dir="\$ANT_LIB" \
          org.apache.tools.ant.launch.Launcher \$NIX_ANT_ARGS \$ANT_ARGS \
          -cp "\$CLASSPATH" "\$@"
      EOF

      chmod +x $out/bin/ant
    ''; # */

  meta = {
    homepage = http://ant.apache.org/;
    description = "A Java-based build tool";

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

    license = stdenv.lib.licenses.asl20;
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.all;
  };
}
