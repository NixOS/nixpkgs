{ stdenv, fetchurl, coursier,
 autoPatchelfHook, 
 lib, zlib }:

let
  baseName = "bloop";
  version = "1.4.1";

  client = stdenv.mkDerivation {
    name = "${baseName}-client-${version}";

    nativeBuildInputs = [ autoPatchelfHook ] ;
    phases = [ "installPhase" "fixupPhase" ];
    buildInputs = [ stdenv.cc.cc.lib zlib] ;

    installPhase = ''
      mkdir -p $out/bin
 
      export COURSIER_CACHE=$(pwd)
      ${coursier}/bin/coursier install bloop:${version} \
                               --repository "bintray:scalameta/maven" \
                               --repository "bintray:scalacenter/releases" \
                               --repository "https://oss.sonatype.org/content/repositories/staging" \
                               --force \
                               --install-dir $out
    '';
    
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash     = "01hgv0j0a4v8iqi638rcqdirpa30jwfp7gh7dvsk32apx003ylvb";
  };

  server = stdenv.mkDerivation {
    name = "${baseName}-server-${version}";
    buildCommand = ''
      mkdir -p $out/bin

      export COURSIER_CACHE=$(pwd)
      ${coursier}/bin/coursier bootstrap ch.epfl.scala:bloop-frontend_2.12:${version} \
                               --repository "bintray:scalameta/maven" \
                               --repository "bintray:scalacenter/releases" \
                               --repository "https://oss.sonatype.org/content/repositories/staging" \
                               --deterministic \
                               --force \
                               --main bloop.Server \
                               --output $out/blp-server
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash     = "01kyzb374kyicm1nmx6vzz42gj8cd9m6bd5dgrajkcr6q09jfgbg";
  };

  zsh = stdenv.mkDerivation {
    name = "${baseName}-zshcompletion-${version}";

    src = fetchurl {
      url = "https://raw.githubusercontent.com/scalacenter/bloop/v${version}/etc/zsh/_bloop";
      sha256 = "1xzg0qfkjdmzm3mvg82mc4iia8cl7b6vbl8ng4ir2xsz00zjrlsq";
    };

    phases = [ "installPhase" ];

    installPhase = ''cp $src $out'';
  };
in
stdenv.mkDerivation {
  name = "${baseName}-${version}";

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/zsh/site-functions

    ln -s ${server}/blp-server $out/bin/blp-server

    ln -s ${zsh} $out/share/zsh/site-functions/_bloop
    ln -s ${client}/.bloop.aux $out/bin/bloop
  '';

  meta = with stdenv.lib; {
    homepage = "https://scalacenter.github.io/bloop/";
    license = licenses.asl20;
    description = "Bloop is a Scala build server and command-line tool to make the compile and test developer workflows fast and productive in a build-tool-agnostic way.";
    maintainers = with maintainers; [ tomahna ];
  };
}
