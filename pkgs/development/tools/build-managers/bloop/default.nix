{ stdenv, lib, fetchurl, coursier, python, makeWrapper, zlib }:

let
  baseName = "bloop";
  version = "1.4.1";

  server = stdenv.mkDerivation {
    name = "${baseName}-server-${version}";
    buildCommand = ''
      export COURSIER_CACHE=$(pwd)
      ${coursier}/bin/coursier install bloop:${version} --dir $out
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash     = "095w2yhb7ixlg3qzspn2c6ff6571gdnl4crwxh1cijf2nabq5kjk";
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

  installPhase = let
    libPath = lib.makeLibraryPath [stdenv.cc.cc zlib] ;
  in ''
    mkdir -p $out/bin
    mkdir -p $out/share/zsh/site-functions

    cp ${server}/.bloop.aux ./.bloop.aux
    chmod +w .bloop.aux
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" .bloop.aux
    patchelf --set-rpath ${libPath} .bloop.aux
    chmod 555 .bloop.aux
    cp .bloop.aux $out/bin/.bloop.aux
    cat ${server}/bloop | sed -e 's#\$(cd "\$(dirname "\$0")"; pwd)/.bloop.aux#'"$out"'/bin/.bloop.aux#' > $out/bin/bloop
    chmod +x $out/bin/bloop
    ln -s ${zsh} $out/share/zsh/site-functions/_bloop
  '';

  meta = with stdenv.lib; {
    homepage = "https://scalacenter.github.io/bloop/";
    license = licenses.asl20;
    description = "Bloop is a Scala build server and command-line tool to make the compile and test developer workflows fast and productive in a build-tool-agnostic way.";
    maintainers = with maintainers; [ tomahna ];
  };
}
