{ stdenv, lib, fetchzip, jdk, makeWrapper, coreutils, curl }:

stdenv.mkDerivation rec {
  version = "0.92.2";
  pname = "jbang";

  src = fetchzip {
    url = "https://github.com/jbangdev/jbang/releases/download/v${version}/${pname}-${version}.tar";
    sha256 = "0gbdbjyyh2if3yfmwfd6d3yq8r25inhw7n44jbjw1pdqb6gk44z1";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    rm bin/jbang.{cmd,ps1}
    cp -r . $out
    wrapProgram $out/bin/jbang \
      --set JAVA_HOME ${jdk} \
      --set PATH ${lib.makeBinPath [ coreutils jdk curl ]}
    runHook postInstall
  '';

  installCheckPhase = ''
    $out/bin/jbang --version 2>&1 | grep -q "${version}"
  '';

  meta = with lib; {
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
