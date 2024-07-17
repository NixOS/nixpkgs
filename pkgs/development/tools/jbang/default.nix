{
  stdenv,
  lib,
  fetchzip,
  jdk,
  makeWrapper,
  coreutils,
  curl,
}:

stdenv.mkDerivation rec {
  version = "0.117.1";
  pname = "jbang";

  src = fetchzip {
    url = "https://github.com/jbangdev/jbang/releases/download/v${version}/${pname}-${version}.tar";
    sha256 = "sha256-LQ9xXTutKhAnAt51mglP/zc7k1v2X/QLwEY31M8SmzM=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    rm bin/jbang.{cmd,ps1}
    cp -r . $out
    wrapProgram $out/bin/jbang \
      --set JAVA_HOME ${jdk} \
      --set PATH ${
        lib.makeBinPath [
          (placeholder "out")
          coreutils
          jdk
          curl
        ]
      }
    runHook postInstall
  '';

  installCheckPhase = ''
    $out/bin/jbang --version 2>&1 | grep -q "${version}"
  '';

  meta = with lib; {
    description = "Run java as scripts anywhere";
    mainProgram = "jbang";
    longDescription = ''
      jbang uses the java language to build scripts similar to groovy scripts. Dependencies are automatically
      downloaded and the java code runs.
    '';
    homepage = "https://www.jbang.dev";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ moaxcp ];
  };
}
