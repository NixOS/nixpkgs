{ stdenv, lib, fetchurl }:
let
  platform = {
    x86_64-linux = "linux_amd64";
    aarch64-linux = "linux_arm64";
    x86_64-darwin = "darwin_amd64";
    aarch64-darwin = "darwin_arm64";
  }.${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");

  hash = {
    x86_64-linux = "sha256-ZCmy+4jyEzrto8R9kE7tNDoy9Pq/lVjkR6dZHMyK5AE=";
    aarch64-linux = "sha256-qEl9ch4qNNtNniyZM56dr7jtxUD8ZqKq1mxbkl7ISfw=";
    x86_64-darwin = "sha256-vsBOYhvXmEg7tOIxkDigLOu9G2jUjqg9rB4B/L7bd64=";
    aarch64-darwin = "sha256-YI2kOHkQ1FF/Y8EWF/H8dPwnrSkjwqWfOtDrd3gdVtY=";
  }.${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation rec {
  pname = "aspect-cli";
  version = "5.5.4";

  src = fetchurl {
    inherit hash;
    url = "https://github.com/aspect-build/aspect-cli/releases/download/${version}/aspect-${platform}";
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp $src $out/bin/aspect
    chmod +x $out/bin/aspect

    # Symlinking `bazel` to `aspect` so both things are available in the PATH.
    ln -s $out/bin/aspect $out/bin/bazel

    runHook postInstall
  '';

  meta = with lib; {
    description = "Drop-in replacement for the bazel CLI that comes with Bazel";
    homepage = "https://github.com/aspect-build/aspect-cli";
    changelog = "https://github.com/aspect-build/aspect-cli/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ar3s3ru ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
