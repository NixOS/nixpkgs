{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  installShellFiles,
  makeWrapper,
  jre,
  lib,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "bloop";
  version = "1.5.17";

  platform =
    if stdenv.isLinux && stdenv.isx86_64 then
      "x86_64-pc-linux"
    else if stdenv.isDarwin && stdenv.isx86_64 then
      "x86_64-apple-darwin"
    else
      throw "unsupported platform";

  bloop-bash = fetchurl {
    url = "https://github.com/scalacenter/bloop/releases/download/v${version}/bash-completions";
    sha256 = "sha256-2mt+zUEJvQ/5ixxFLZ3Z0m7uDSj/YE9sg/uNMjamvdE=";
  };

  bloop-fish = fetchurl {
    url = "https://github.com/scalacenter/bloop/releases/download/v${version}/fish-completions";
    sha256 = "sha256-eFESR6iPHRDViGv+Fk3sCvPgVAhk2L1gCG4LnfXO/v4=";
  };

  bloop-zsh = fetchurl {
    url = "https://github.com/scalacenter/bloop/releases/download/v${version}/zsh-completions";
    sha256 = "sha256-WNMsPwBfd5EjeRbRtc06lCEVI2FVoLfrqL82OR0G7/c=";
  };

  bloop-binary = fetchurl rec {
    url = "https://github.com/scalacenter/bloop/releases/download/v${version}/bloop-${platform}";
    sha256 =
      if stdenv.isLinux && stdenv.isx86_64 then
        "sha256-lP7j7pPG7wC36sG+d80F2E6ZHPZcOZN/M/j6CniaNGY="
      else if stdenv.isDarwin && stdenv.isx86_64 then
        "sha256-awSBYSN4do4w9dAx6JwoexiptfC01vW1/o53Tp13xj0="
      else
        throw "unsupported platform";
  };

  dontUnpack = true;
  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ] ++ lib.optional stdenv.isLinux autoPatchelfHook;
  buildInputs = [
    stdenv.cc.cc.lib
    zlib
  ];
  propagatedBuildInputs = [ jre ];

  installPhase = ''
    runHook preInstall

    install -D -m 0755 ${bloop-binary} $out/.bloop-wrapped

    makeWrapper $out/.bloop-wrapped $out/bin/bloop

    #Install completions
    installShellCompletion --name bloop --bash ${bloop-bash}
    installShellCompletion --name _bloop --zsh ${bloop-zsh}
    installShellCompletion --name bloop.fish --fish ${bloop-fish}

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://scalacenter.github.io/bloop/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.asl20;
    description = "A Scala build server and command-line tool to make the compile and test developer workflows fast and productive in a build-tool-agnostic way";
    mainProgram = "bloop";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
    maintainers = with maintainers; [
      kubukoz
      tomahna
    ];
  };
}
