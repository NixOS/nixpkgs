{ fetchurl
, frink
, jdk
, lib
, rlwrap
, stdenv
, testers
}:
stdenv.mkDerivation rec {
  pname = "frink";
  version = "2023-01-31";

  src = fetchurl {
    # Upstream does not provide versioned download links
    url = "https://web.archive.org/web/20230202134810/https://frinklang.org/frinkjar/frink.jar";
    sha256 = "sha256-xs1FQvFPgeAxscAiwBBP8N8aYe0OlsYbH/vbzzCbYZc=";
  };

  dontUnpack = true;

  buildInputs = [ jdk rlwrap ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib

    cp ${src} $out/lib/frink.jar

    cat > "$out/bin/frink" << EOF
    #!${stdenv.shell}
    exec ${rlwrap}/bin/rlwrap ${jdk}/bin/java -classpath "$out/lib/frink.jar" frink.gui.FrinkStarter "\$@"
    EOF

    chmod a+x "$out/bin/frink"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A practical calculating tool and programming language";
    homepage = "https://frinklang.org/";
    license = licenses.unfree;
    sourceProvenance = [ sourceTypes.binaryBytecode ];
    maintainers = [ maintainers.stefanfehrenbach ];
  };

  passthru.tests = {
    callFrinkVersion = testers.testVersion {
      package = frink;
      command = "frink -e 'FrinkVersion[]'";
    };
  };
}
