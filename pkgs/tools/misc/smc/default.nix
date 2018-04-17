{ stdenv, fetchurl, jre }:

stdenv.mkDerivation rec {
  name = "smc-6.6.3";

  src = fetchurl {
    url = "mirror://sourceforge/project/smc/smc/6_6_3/smc_6_6_3.tgz";
    sha256 = "1gv0hrgdl4wp562virpf9sib6pdhapwv4zvwbl0d5f5xyx04il11";
  };

  # Prebuilt Java package.
  installPhase = ''
    mkdir -p "$out/bin"
    mkdir -p "$out/share/smc"
    mkdir -p "$out/share/smc/lib"
    mkdir -p "$out/share/icons"
    mkdir -p "$out/share/java"

    cp bin/Smc.jar "$out/share/java/"
    cp -r examples/ docs/ tools/ README.txt LICENSE.txt "$out/share/smc/"
    cp -r lib/* "$out/share/smc/lib/"
    cp misc/smc.ico "$out/share/icons/"

    cat > "$out/bin/smc" << EOF
    #!${stdenv.shell}
    ${jre}/bin/java -jar "$out/share/java/Smc.jar" "\$@"
    EOF
    chmod a+x "$out/bin/smc"
  '';

  meta = with stdenv.lib; {
    description = "Generate state machine code from text input (state diagram)";
    longDescription = ''
      SMC (State Machine Compiler) takes a text input file describing states,
      events and actions of a state machine and generates source code that
      implements the state machine.

      SMC supports many target languages:
      C, C++, DotNet, Groovy, java, Java, JavaScript, Lua, ObjC, Perl, Php,
      Python, Ruby, Scala, Tcl.

      SMC can also generate GraphViz state diagrams from the input file.
    '';
    homepage = http://smc.sourceforge.net/;
    license = licenses.mpl11;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
