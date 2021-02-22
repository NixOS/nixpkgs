{ stdenv
, fetchurl
, coursier
, autoPatchelfHook
, installShellFiles
, jre
, lib
, zlib
}:

stdenv.mkDerivation rec {
  pname = "bloop";
  version = "1.4.6";

  bloop-coursier-channel = fetchurl {
    url = "https://github.com/scalacenter/bloop/releases/download/v${version}/bloop-coursier.json";
    sha256 = "1fx80yrf03llhxcd8az5vzralz01wdfk7000q8l04rj1ax3daqia";
  };

  bloop-bash = fetchurl {
    url = "https://github.com/scalacenter/bloop/releases/download/v${version}/bash-completions";
    sha256 = "1ldxlqv353gvhdn4yq7z506ywvnjv6fjsi8wigwhzg89876pwsys";
  };

  bloop-fish = fetchurl {
    url = "https://github.com/scalacenter/bloop/releases/download/v${version}/fish-completions";
    sha256 = "1pa8h81l2498q8dbd83fzipr99myjwxpy8xdgzhvqzdmfv6aa4m0";
  };

  bloop-zsh = fetchurl {
    url = "https://github.com/scalacenter/bloop/releases/download/v${version}/zsh-completions";
    sha256 = "1xzg0qfkjdmzm3mvg82mc4iia8cl7b6vbl8ng4ir2xsz00zjrlsq";
  };

  bloop-coursier = stdenv.mkDerivation rec {
    name = "${pname}-coursier-${version}";

    platform = if stdenv.isLinux && stdenv.isx86_64 then "x86_64-pc-linux"
               else if stdenv.isDarwin && stdenv.isx86_64 then "x86_64-apple-darwin"
               else throw "unsupported platform";

    phases = [ "installPhase" ];
    installPhase = ''
      export COURSIER_CACHE=$(pwd)
      export COURSIER_JVM_CACHE=$(pwd)

      mkdir channel
      ln -s ${bloop-coursier-channel} channel/bloop.json
      ${coursier}/bin/coursier install --install-dir $out --install-platform ${platform} --default-channels=false --channel channel --only-prebuilt=true bloop

      # Remove binary part of the coursier launcher script to make derivation output hash stable
      sed -i '5,$ d' $out/bloop
   '';

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash     = if stdenv.isLinux && stdenv.isx86_64 then "1hg02a3ildgqv8864zg08hvk4y0kmsxsg7ncbsl933rclhk2lybd"
                     else if stdenv.isDarwin && stdenv.isx86_64 then "1i9kh4h5w3gr4w6rf5m7xpfqwps91mfddl1zk25v7f6vsraayam0"
                     else throw "unsupported platform";
  };

  dontUnpack = true;
  nativeBuildInputs = [ autoPatchelfHook installShellFiles ];
  buildInputs = [ stdenv.cc.cc.lib zlib ];
  propagatedBuildInputs = [ jre ];

  installPhase = ''
    export COURSIER_CACHE=$(pwd)
    export COURSIER_JVM_CACHE=$(pwd)

    mkdir -p $out/bin
    cp ${bloop-coursier}/bloop $out/bloop
    cp ${bloop-coursier}/.bloop.aux $out/.bloop.aux
    ln -s $out/bloop $out/bin/bloop

    # patch the bloop launcher so that it works when symlinked
    sed "s|\$(dirname \"\$0\")|$out|" -i $out/bloop

    #Install completions
    installShellCompletion --name bloop --bash ${bloop-bash}
    installShellCompletion --name _bloop --zsh ${bloop-zsh}
    installShellCompletion --name bloop.fish --fish ${bloop-fish}
  '';

  meta = with lib; {
    homepage = "https://scalacenter.github.io/bloop/";
    license = licenses.asl20;
    description = "A Scala build server and command-line tool to make the compile and test developer workflows fast and productive in a build-tool-agnostic way";
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ tomahna ];
  };
}
