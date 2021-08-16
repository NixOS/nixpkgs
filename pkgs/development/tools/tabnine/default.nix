{ stdenv, lib, fetchurl, unzip }:
let
  platform =
    if stdenv.hostPlatform.system == "x86_64-linux" then {
      name = "x86_64-unknown-linux-musl";
      sha256 = "sha256-pttjlx7WWE3nog9L1APp8HN+a4ShhlBj5irHOaPgqHw=";
    } else if stdenv.hostPlatform.system == "x86_64-darwin" then {
      name = "x86_64-apple-darwin";
      sha256 = "sha256-Vxmhl4/bhRDeByGgkdSF8yEY5wI23WzT2iH1OFkEpck=";
    } else throw "Not supported on ${stdenv.hostPlatform.system}";
in
stdenv.mkDerivation rec {
  pname = "tabnine";
  # You can check the latest version with `curl -sS https://update.tabnine.com/bundles/version`
  version = "3.5.37";

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
    platforms = [ "x86_64-darwin" "x86_64-linux" ];
    maintainers = with maintainers; [ lovesegfault ];
  };
}
