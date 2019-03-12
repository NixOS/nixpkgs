{ pkgs,
  stdenv,
  fetchurl,
  unzip
}:

stdenv.mkDerivation rec {
  version = "9.0.0";
  name = "ghidra-${version}";

  src = fetchurl {
            url = "https://ghidra-sre.org/ghidra_9.0_PUBLIC_20190228.zip";
            sha256 = "1cnngzy1rpf9bmglff7zarm3lzybggl2zca826xwvpmr4j8d4r9v";
        };
  
  buildInputs = [unzip];

  dontBuild = true;
  
  installPhase = ''    
      mkdir -p $out/bin
      cp -r * $out
      echo -e "#!/usr/bin/env sh\n PATH=\$PATH:${pkgs.openjdk11}/bin \$(dirname \$0)/../ghidraRun" > $out/bin/ghidraRun
      chmod +x $out/bin/ghidraRun
  '';

  meta = with stdenv.lib; {
    description = "Software reverse engineering suite";

    longDescription = ''
      A software reverse engineering (SRE) suite of tools developed by NSA's Research Directorate in support of the Cybersecurity mission
      '';

    homepage = https://ghidra-sre.org/;

    license = licenses.asl20;

    platforms = with platforms; linux;
    maintainers = with maintainers; [ nea j03 ];
  };
}

