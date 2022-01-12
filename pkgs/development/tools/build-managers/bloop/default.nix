{ stdenv
, fetchurl
, coursier
, autoPatchelfHook
, installShellFiles
, makeWrapper
, jre
, lib
, zlib
}:

stdenv.mkDerivation rec {
  pname = "bloop";
  version = "1.4.11";

  bloop-coursier-channel = fetchurl {
    url = "https://github.com/scalacenter/bloop/releases/download/v${version}/bloop-coursier.json";
    sha256 = "CoF/1nggjaL17SWmWDcKicfgoyqpOSZUse8f+3TgD0E=";
  };

  bloop-bash = fetchurl {
    url = "https://github.com/scalacenter/bloop/releases/download/v${version}/bash-completions";
    sha256 = "2mt+zUEJvQ/5ixxFLZ3Z0m7uDSj/YE9sg/uNMjamvdE=";
  };

  bloop-fish = fetchurl {
    url = "https://github.com/scalacenter/bloop/releases/download/v${version}/fish-completions";
    sha256 = "oBKlzHa1fbzhf60jfzuXvqaUb/xuoLYawigRQQOCSN0=";
  };

  bloop-zsh = fetchurl {
    url = "https://github.com/scalacenter/bloop/releases/download/v${version}/zsh-completions";
    sha256 = "WNMsPwBfd5EjeRbRtc06lCEVI2FVoLfrqL82OR0G7/c=";
  };

  bloop-coursier = stdenv.mkDerivation rec {
    name = "${pname}-coursier-${version}";

    platform = if stdenv.isLinux && stdenv.isx86_64 then "x86_64-pc-linux"
    else if stdenv.isDarwin && stdenv.isx86_64 then "x86_64-apple-darwin"
    else throw "unsupported platform";

    dontUnpack = true;
    installPhase = ''
      runHook preInstall

      export COURSIER_CACHE=$(pwd)
      export COURSIER_JVM_CACHE=$(pwd)

      mkdir channel
      ln -s ${bloop-coursier-channel} channel/bloop.json
      ${coursier}/bin/cs install --install-dir . --install-platform ${platform} --default-channels=false --channel channel --only-prebuilt=true bloop

      # Only keeping the binary, we'll wrap it ourselves
      # This guarantees the output of this fixed-output derivation doesn't have references to itself
      install -D -m 0755 .bloop.aux $out

      runHook postInstall
    '';

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = if stdenv.isLinux && stdenv.isx86_64 then "0c02n779z4l7blzla5820bzfhblbp5nlizx9f8wns4miwnph357f"
    else if stdenv.isDarwin && stdenv.isx86_64 then "1gy5k9ii86rxyv2v9if4n1clvmb1hi4ym32mp6miwgcjla10sv30"
    else throw "unsupported platform";
  };

  dontUnpack = true;
  nativeBuildInputs = [ autoPatchelfHook installShellFiles makeWrapper ];
  buildInputs = [ stdenv.cc.cc.lib zlib ];
  propagatedBuildInputs = [ jre ];

  installPhase = ''
    runHook preInstall

    export COURSIER_CACHE=$(pwd)
    export COURSIER_JVM_CACHE=$(pwd)

    install -D -m 0755 ${bloop-coursier} $out/.bloop-wrapped

    makeWrapper $out/.bloop-wrapped $out/bin/bloop \
      --set CS_NATIVE_LAUNCHER true \
      --set IS_CS_INSTALLED_LAUNCHER true

    #Install completions
    installShellCompletion --name bloop --bash ${bloop-bash}
    installShellCompletion --name _bloop --zsh ${bloop-zsh}
    installShellCompletion --name bloop.fish --fish ${bloop-fish}

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://scalacenter.github.io/bloop/";
    license = licenses.asl20;
    description = "A Scala build server and command-line tool to make the compile and test developer workflows fast and productive in a build-tool-agnostic way";
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    maintainers = with maintainers; [ kubukoz tomahna ];
  };
}
