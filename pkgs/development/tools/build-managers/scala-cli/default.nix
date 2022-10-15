{ stdenv
, coreutils
, lib
, installShellFiles
, zlib
, autoPatchelfHook
, fetchurl
, makeWrapper
, callPackage
, jre
}:

assert lib.versionAtLeast jre.version "17.0.0";
let
  pname = "scala-cli";
  sources = builtins.fromJSON (builtins.readFile ./sources.json);
  inherit (sources) version assets;

  platforms = builtins.attrNames assets;
in
stdenv.mkDerivation {
  inherit pname version;
  nativeBuildInputs = [ installShellFiles makeWrapper ]
    ++ lib.optional stdenv.isLinux autoPatchelfHook;
  buildInputs = [ coreutils zlib stdenv.cc.cc ];
  src =
    let
      asset = assets."${stdenv.hostPlatform.system}" or (throw "Unsupported platform ${stdenv.hostPlatform.system}");
    in
    fetchurl {
      url = "https://github.com/Virtuslab/scala-cli/releases/download/v${version}/${asset.asset}";
      sha256 = asset.sha256;
    };
  unpackPhase = ''
    runHook preUnpack
    gzip -d < $src > scala-cli
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 scala-cli $out/bin/.scala-cli-wrapped
    makeWrapper $out/bin/.scala-cli-wrapped $out/bin/scala-cli \
      --set JAVA_HOME ${jre.home}
    runHook postInstall
  '';

  # We need to call autopatchelf before generating completions
  dontAutoPatchelf = true;

  postFixup = lib.optionalString stdenv.isLinux ''
    autoPatchelf $out
  '' + ''
    # hack to ensure the completion function looks right
    # as $0 is used to generate the compdef directive
    mkdir temp
    cp $out/bin/.scala-cli-wrapped temp/scala-cli
    PATH="./temp:$PATH"

    installShellCompletion --cmd scala-cli \
      --bash <(scala-cli completions bash) \
      --zsh <(scala-cli completions zsh)
  '';

  meta = with lib; {
    homepage = "https://scala-cli.virtuslab.org";
    downloadPage = "https://github.com/VirtusLab/scala-cli/releases/v${version}";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.asl20;
    description = "Command-line tool to interact with the Scala language";
    maintainers = [ maintainers.kubukoz ];
  };

  passthru.updateScript = callPackage ./update.nix { } { inherit platforms pname version; };
}
