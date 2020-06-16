{ stdenv, fetchurl, coursier,
 autoPatchelfHook, 
 lib, zlib }:

stdenv.mkDerivation rec {
  basename = "bloop";
  version = "1.4.1";
  name = "bloop-${version}";

  bloop-coursier-channel = fetchurl {
    url = "https://github.com/scalacenter/bloop/releases/download/v${version}/bloop-coursier.json";
    sha256 = "2e6a873183e5e22712913bfdab1331d0a7792167c369fee5be0c83e27572fe12";
  };

  bloop-bash = fetchurl {
    url = "https://github.com/scalacenter/bloop/releases/download/v${version}/bash-completions";
    sha256 = "da6b7ecd4109bd0ff98b1c452d9dd9d26eee0d28ff604f6c83fb8d3236a6bdd1";
  };

  bloop-fish = fetchurl {
    url = "https://github.com/scalacenter/bloop/releases/download/v${version}/fish-completions";
    sha256 = "1pa8h81l2498q8dbd83fzipr99myjwxpy8xdgzhvqzdmfv6aa4m0";
  };

  bloop-zsh = fetchurl {
    url = "https://github.com/scalacenter/bloop/releases/download/v${version}/zsh-completions";
    sha256 = "1xzg0qfkjdmzm3mvg82mc4iia8cl7b6vbl8ng4ir2xsz00zjrlsq";
  };

  bloop-coursier = stdenv.mkDerivation {
    name = "${basename}-coursier-${version}";

    nativeBuildInputs = [ autoPatchelfHook ] ;
    phases = [ "installPhase" "fixupPhase" ];
    buildInputs = [ stdenv.cc.cc.lib zlib ] ;

    installPhase = ''
      export COURSIER_CACHE=$(pwd)
      export COURSIER_JVM_CACHE=$(pwd)

      mkdir channel
      ln -s ${bloop-coursier-channel} channel/bloop.json
      ${coursier}/bin/coursier install --install-dir $out --default-channels=false --channel channel --only-prebuilt=true bloop

      # Remove binary part of the coursier launcher script to make derivation output hash stable
      sed -i '5,$ d' $out/bloop
   '';

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash     = "1f5hf80s71w5g61s8vcaccabsn9xvkf05jgbnwwx01i3f23w31vb";
  };

  buildCommand = ''
    export COURSIER_CACHE=$(pwd)
    export COURSIER_JVM_CACHE=$(pwd)

    mkdir -p $out/bin
    cp ${bloop-coursier}/bloop $out/bloop
    ln -s ${bloop-coursier}/.bloop.aux $out/.bloop.aux
    ln -s $out/bloop $out/bin/bloop

    # patch the bloop launcher so that it works when symlinked
    sed "s|\$(dirname \"\$0\")|$out|" -i $out/bloop

    #Install completions
    mkdir -p $out/etc/bash_completion.d
    ln -s ${bloop-bash} $out/etc/bash_completion.d/bloop
    mkdir -p $out/share/zsh/site-functions
    ln -s ${bloop-zsh} $out/share/zsh/site-functions/_bloop
    mkdir -p $out/usr/share/fish/vendor_completions.d/
    ln -s ${bloop-fish} $out/usr/share/fish/vendor_completions.d/bloop.fish
  '';

  meta = with stdenv.lib; {
    homepage = "https://scalacenter.github.io/bloop/";
    license = licenses.asl20;
    description = "Bloop is a Scala build server and command-line tool to make the compile and test developer workflows fast and productive in a build-tool-agnostic way.";
    maintainers = with maintainers; [ tomahna ];
  };
}
