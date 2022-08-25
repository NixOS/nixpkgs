{ stdenv, lib, fetchurl, unzip }:
let
  # You can check the latest version with `curl -sS https://update.tabnine.com/bundles/version`
  # There's a handy prefetch script in ./fetch-latest.sh
  version = "4.4.123";
  supportedPlatforms = {
    "x86_64-linux" = {
      name = "x86_64-unknown-linux-musl";
      hash = "sha256-mkG7Fd82L5vnS/K1UQF/JZCdQYsnPZ1iTISqFjXXnq0=";
    };
    "x86_64-darwin" = {
      name = "x86_64-apple-darwin";
      hash = "sha256-+B9Oobhh1TmDoRhNlObn5jYrDgsjvpTKguwj3wbkaO0=";
    };
    "aarch64-darwin" = {
      name = "aarch64-apple-darwin";
      hash = "sha256-HNZSQaVd8530sM4JpUTWfo7aTfKaJHg00u+M/x/pKdQ=";
    };
  };
  platform =
    if (builtins.hasAttr stdenv.hostPlatform.system supportedPlatforms) then
      builtins.getAttr (stdenv.hostPlatform.system) supportedPlatforms
    else
      throw "Not supported on ${stdenv.hostPlatform.system}";
in
stdenv.mkDerivation {
  pname = "tabnine";
  inherit version;

  src = fetchurl {
    url = "https://update.tabnine.com/bundles/${version}/${platform.name}/TabNine.zip";
    inherit (platform) hash;
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
    platforms = attrNames supportedPlatforms;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
