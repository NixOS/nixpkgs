{ stdenv, coreutils, lib, installShellFiles, zlib, autoPatchelfHook, fetchurl }:

let
  version = "0.1.5";
  assets = {
    x86_64-darwin = {
      asset = "scala-cli-x86_64-apple-darwin.gz";
      sha256 = "1sczbvvhh1ff8mdb6zj4q3fnrz1qsqmr58jlb1s3fy1wv2p5ywxl";
    };
    x86_64-linux = {
      asset = "scala-cli-x86_64-pc-linux.gz";
      sha256 = "1ahvjgcghh1pmgfsajg0b8bf5aaqxdx0f6b6qgljs0xfqm7zs05v";
    };
  };
in
stdenv.mkDerivation {
  pname = "scala-cli";
  inherit version;
  nativeBuildInputs = [ installShellFiles ]
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
    install -Dm755 scala-cli $out/bin/scala-cli
    runHook postInstall
  '';

  # We need to call autopatchelf before generating completions
  dontAutoPatchelf = true;

  postFixup = lib.optionalString stdenv.isLinux ''
    autoPatchelf $out
  '' + ''
    # hack to ensure the completion function looks right
    # as $0 is used to generate the compdef directive
    PATH="$out/bin:$PATH"

    installShellCompletion --cmd scala-cli \
      --bash <(scala-cli completions bash) \
      --zsh <(scala-cli completions zsh)
  '';

  meta = with lib; {
    homepage = "https://scala-cli.virtuslab.org";
    downloadPage = "https://github.com/VirtusLab/scala-cli/releases/v${version}";
    license = licenses.asl20;
    description = "Command-line tool to interact with the Scala language";
    maintainers = [ maintainers.kubukoz ];
    platforms = builtins.attrNames assets;
  };
}
