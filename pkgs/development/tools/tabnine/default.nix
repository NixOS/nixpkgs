{ stdenv, lib, fetchurl, unzip }:
let
  supportedPlatforms = {
    "x86_64-linux" = {
      name = "x86_64-unknown-linux-musl";
      sha256 = "sha256-On+Sokm2+BV3JbIwK8oPO6882FOWBlgSaAp3VAyR+RM=";
    };
    "x86_64-darwin" = {
      name = "x86_64-apple-darwin";
      sha256 = "sha256-4YCm42mVcsEvY4I5MWrnbfgUIU7KUIrEirvjN8ISIr0=";
    };
    "aarch64-darwin" = {
      name = "aarch64-apple-darwin";
      sha256 = "sha256-HN4o5bGX389eAR7ea5EY1JlId8q4lSPGJ4cZo9c2aP4=";
    };
  };
  platform =
    if (builtins.hasAttr stdenv.hostPlatform.system supportedPlatforms) then
      builtins.getAttr (stdenv.hostPlatform.system) supportedPlatforms
    else
      throw "Not supported on ${stdenv.hostPlatform.system}";
in
stdenv.mkDerivation rec {
  pname = "tabnine";
  # You can check the latest version with `curl -sS https://update.tabnine.com/bundles/version`
  version = "3.7.25";

  src = fetchurl {
    url = "https://update.tabnine.com/bundles/${version}/${platform.name}/TabNine.zip";
    inherit (platform) sha256;
  };

  dontBuild = true;

  # Work around the "unpacker appears to have produced no directories"
  # case that happens when the archive doesn't have a subdirectory.
  setSourceRoot = "sourceRoot=`pwd`";

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall
    install -Dm755 TabNine $out/bin/TabNine
    install -Dm755 TabNine-deep-cloud $out/bin/TabNine-deep-cloud
    install -Dm755 TabNine-deep-local $out/bin/TabNine-deep-local
    install -Dm755 WD-TabNine $out/bin/WD-TabNine
    runHook postInstall
  '';

  passthru.platform = platform.name;

  meta = with lib; {
    homepage = "https://tabnine.com";
    description = "Smart Compose for code that uses deep learning to help you write code faster";
    license = licenses.unfree;
    platforms = [ "x86_64-darwin" "aarch64-darwin" "x86_64-linux" ];
    maintainers = with maintainers; [ lovesegfault ];
  };
}
