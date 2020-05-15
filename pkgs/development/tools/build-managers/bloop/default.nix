{ stdenv, lib, fetchurl, coursier, python, makeWrapper }:

let
  baseName = "bloop";
  version = "1.3.4";
  nailgunCommit = "d7ed5db"; # Fetched from https://github.com/scalacenter/bloop/releases/download/v${version}/install.py

  client = stdenv.mkDerivation {
    name = "${baseName}-client-${version}";

    src = fetchurl {
      url = "https://raw.githubusercontent.com/scalacenter/nailgun/${nailgunCommit}/pynailgun/ng.py";
      sha256 = "0lrj25m0nvphz2i5mqjwccpyrd7gn8a5k22k5khrpdh6ldxqis8a";
    };

    phases = [ "installPhase" ];

    installPhase = ''cp $src $out'';
  };

  server = stdenv.mkDerivation {
    name = "${baseName}-server-${version}";
    buildCommand = ''
      mkdir -p $out/bin

      export COURSIER_CACHE=$(pwd)
      ${coursier}/bin/coursier bootstrap ch.epfl.scala:bloop-frontend_2.12:${version} \
        -r "bintray:scalameta/maven" \
        -r "bintray:scalacenter/releases" \
        -r "https://oss.sonatype.org/content/repositories/staging" \
        --deterministic \
        -f --main bloop.Server -o $out/bin/blp-server
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash     = "1z33ip6hgfwiixm2gimz819p5cnxn1fmxb3ryyf77jzwsx7py718";
  };

  zsh = stdenv.mkDerivation {
    name = "${baseName}-zshcompletion-${version}";

    src = fetchurl {
      url = "https://raw.githubusercontent.com/scalacenter/bloop/v${version}/etc/zsh/_bloop";
      sha256 = "09qq5888vaqlqan2jbs2qajz2c3ff13zj8r0x2pcxsqmvlqr02hp";
    };

    phases = [ "installPhase" ];

    installPhase = ''cp $src $out'';
  };
in
stdenv.mkDerivation {
  name = "${baseName}-${version}";

  buildInputs = [ makeWrapper ];

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/zsh/site-functions

    ln -s ${server}/bin/blp-server $out/blp-server
    ln -s ${zsh} $out/share/zsh/site-functions/_bloop

    cp ${client} $out/bloop
    chmod +x $out/bloop
    makeWrapper $out/bloop $out/bin/bloop \
      --prefix PATH : ${lib.makeBinPath [ python ]}
  '';

  meta = with stdenv.lib; {
    homepage = "https://scalacenter.github.io/bloop/";
    license = licenses.asl20;
    description = "Bloop is a Scala build server and command-line tool to make the compile and test developer workflows fast and productive in a build-tool-agnostic way.";
    maintainers = with maintainers; [ tomahna ];
  };
}
