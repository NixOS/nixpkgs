{ stdenv
, lib
, fetchzip
}:

let
  os = if stdenv.isDarwin then "macos" else "linux";
  arch = if stdenv.isAarch64 then "aarch64" else "x86_64";
  platform = "${os}-${arch}";
in
stdenv.mkDerivation rec {
  pname = "urbit";
  version = "2.6";

  src = fetchzip {
    url = "https://github.com/urbit/vere/releases/download/vere-v${version}/${platform}.tgz";
    sha256 = {
      x86_64-linux = "sha256-VWlIneEmuqqvk6VHX3ocSPOtRuXiIoVUio7EA7LnEXA=";
      aarch64-linux = "sha256-m+IoatTRR9YpkVPE1cs3/TVI31z7Av1wrrBePiaNAHg=";
      x86_64-darwin = "sha256-eWQ37vK9Q1xe/Kso7Ru7wKOUwUIvpIWqD4NVc4XdOOg=";
      aarch64-darwin = "sha256-N4omwDmJpk8kIX2KDht1WVljnJm2JNXswoLsWWc5zoY=";
    }.${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");
  };

  postInstall = ''
    install -m755 -D vere-v${version}-${platform} $out/bin/urbit
  '';

  passthru.updateScript = ./update-bin.sh;

  meta = with lib; {
    homepage = "https://urbit.org";
    description = "An operating function";
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    maintainers = [ maintainers.matthew-levan ];
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
