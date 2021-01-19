{ stdenv, lib, fetchzip, jdk, makeWrapper, coreutils, curl }:

stdenv.mkDerivation rec {
  version = "0.62.0";
  pname = "jbang";

  src = fetchzip {
    url = "https://github.com/jbangdev/jbang/releases/download/v${version}/${pname}-${version}.tar";
    sha256 = "sha256-Ffh08477Wc4yEUo2YBM2yxC288Kq05ZkKXf/XSW2iXc=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    rm bin/jbang.{cmd,ps1}
    rmdir tmp
    cp -r . $out
    wrapProgram $out/bin/jbang \
      --set JAVA_HOME ${jdk} \
      --set PATH ${lib.makeBinPath [ coreutils jdk curl ]}
    runHook postInstall
  '';

  installCheckPhase = ''
    $out/bin/jbang --version 2>&1 | grep -q "${version}"
  '';

  meta = with stdenv.lib; {
    description = "Run java as scripts anywhere";
    longDescription = ''
      jbang uses the java language to build scripts similar to groovy scripts. Dependencies are automatically
      downloaded and the java code runs.
    '';
    homepage = "https://https://www.jbang.dev/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ moaxcp ];
  };
}
