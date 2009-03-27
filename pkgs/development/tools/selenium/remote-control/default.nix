args: with args;
let version = "1.0-beta-2";
in stdenv.mkDerivation {
    name = "selenium-remote-control-${version}-dist";
    src = fetchurl {
      url = "http://release.seleniumhq.org/selenium-remote-control/${version}/selenium-remote-control-${version}-dist.zip";
      sha256 = "0ciyfqvnv0117l2rhw9dclv85mcf3czpimvybj38v3syl7m7yk41";
    };
    phases = "unpackPhase buildPhase";
    buildInputs = [unzip];
    buildPhase = ''
      ensureDir $out/{bin,lib}
      mv * $out/lib
      bin="$out/bin/selenium-remote-control"
      cat >> "$bin" << EOF
      #!/bin/sh
      exec ${jre}/bin/java -jar $out/lib/selenium-server-${version}/selenium-server.jar "\$@"
      EOF
      echo chmod +x "$bin"
      chmod +x "$bin" 
    '';
}
