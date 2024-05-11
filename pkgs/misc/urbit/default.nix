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
  version = "3.0";

  src = fetchzip {
    url = "https://github.com/urbit/vere/releases/download/vere-v${version}/${platform}.tgz";
    sha256 = {
      x86_64-linux = "sha256-wQY3I/HM816vI2NYAvtaYDga64n3nkUEtNd6G8w3hgU=";
      aarch64-linux = "sha256-ZQMzIkvdy+hL2a2eB2bgIFXmCfEdn+f3sKQ8vwVVqPg=";
      x86_64-darwin = "sha256-OWKJQUE061CVgPTbF9y30a65I/iGiqQvBGQMViUTqEc=";
      aarch64-darwin = "sha256-4ksk7XRobjvYMMkWjB0Ka7/Te8E3ddo9eDFx3lgYpZI=";
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
    mainProgram = "urbit";
  };
}
