{ stdenv, lib, fetchurl, coursier, jdk, jre, python, makeWrapper }:

let
  baseName = "bloop";
  version = "1.3.2";
  deps = stdenv.mkDerivation {
    name = "${baseName}-deps-${version}";
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      ${coursier}/bin/coursier fetch ch.epfl.scala:bloop-frontend_2.12:${version} \
        -r "bintray:scalameta/maven" \
        -r "bintray:scalacenter/releases" \
        -r "https://oss.sonatype.org/content/repositories/staging" > deps
      mkdir -p $out/share/java
      cp $(< deps) $out/share/java/
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash     = "1npq02npk6qiwghgr3bqd1ala1kv8hwq1qkmyffvigcq7frkz4r8";
  };
in
stdenv.mkDerivation rec {
  name = "${baseName}-${version}";

  # Fetched from https://github.com/scalacenter/bloop/releases/download/v${version}/install.py
  nailgunCommit = "9327a60a";

  buildInputs = [ jdk makeWrapper deps ];

  phases = [ "installPhase" ];

  client = fetchurl {
    url = "https://raw.githubusercontent.com/scalacenter/nailgun/${nailgunCommit}/pynailgun/ng.py";
    sha256 = "0z4as5ibmzkd145wsch9caiy4037bgg780gcf7pyns0cv9n955b4";
  };

  zshCompletion = fetchurl {
    url = "https://raw.githubusercontent.com/scalacenter/bloop/v${version}/etc/zsh/_bloop";
    sha256 = "09qq5888vaqlqan2jbs2qajz2c3ff13zj8r0x2pcxsqmvlqr02hp";
  };

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/zsh/site-functions

    cp ${client} $out/bin/blp-client
    cp ${zshCompletion} $out/share/zsh/site-functions/_bloop
    chmod +x $out/bin/blp-client

    makeWrapper ${jre}/bin/java $out/bin/blp-server \
      --prefix PATH : ${lib.makeBinPath [ jdk ]} \
      --add-flags "-cp $CLASSPATH bloop.Server"
    makeWrapper $out/bin/blp-client $out/bin/bloop \
      --prefix PATH : ${lib.makeBinPath [ python ]}
  '';

  meta = with stdenv.lib; {
    homepage = https://scalacenter.github.io/bloop/;
    license = licenses.asl20;
    description = "Bloop is a Scala build server and command-line tool to make the compile and test developer workflows fast and productive in a build-tool-agnostic way.";
    maintainers = with maintainers; [ tomahna ];
  };
}
