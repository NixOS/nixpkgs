{ stdenv, fetchurl, jre }:

# let version = "1.0-beta-2";
let version = "1.0-SNAPSHOT-standalone";

in stdenv.mkDerivation {
    /*

    Use this if there is another release..

    name = "selenium-remote-control-${version}-dist";
    src = fetchurl {
      url = "http://release.seleniumhq.org/selenium-remote-control/${version}/selenium-remote-control-${version}-dist.zip";
      sha256 = "0ciyfqvnv0117l2rhw9dclv85mcf3czpimvybj38v3syl7m7yk41";
    };
    buildInputs = [unzip];
    phases = "unpackPhase buildPhase";
    buildPhase = ''
      mkdir -p $out/{bin,lib}
      mv * $out/lib
      bin="$out/bin/selenium-remote-control"
      cat >> "$bin" << EOF
      #!/bin/sh
      exec ${jre}/bin/java -jar $out/lib/selenium-server-${version}/selenium-server.jar "\$@"
      EOF
      chmod +x "$bin" 
    '';
    */

    # this snapshot version starts a firefox from a script file. It only issues a warning about it
    # you still have to pass -DfirefoxDefaultPath=/home/marc/.nix-profile/bin/firefox or such..
    name = "selenium-remote-control-${version}-dist";
    # this dist file has been created using  mvn package  -Dmaven.test.skip=true based on svn rev 2450
    src = fetchurl {
      url = "http://mawercer.de/~nix/selenium-server-1.0-SNAPSHOT-standalone.jar";
      sha256 = "1lqr72a3lmmww1psl19pzp91c9q1dm0314b7y7mz1gnfpwc49y38";
    };
    phases = "buildPhase";
    buildPhase = ''
      mkdir -p $out/{bin,lib}
      cp $src $out/lib/
      bin="$out/bin/selenium-remote-control"
      cat >> "$bin" << EOF
      #!/bin/sh
      exec ${jre}/bin/java -jar "$out/lib/$(basename $src)" "\$@"
      EOF
      chmod +x "$bin" 
    '';
}
