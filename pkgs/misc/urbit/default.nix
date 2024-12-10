{
  stdenv,
  lib,
  fetchzip,
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
    sha256 =
      {
        x86_64-linux = "sha256-ip35d9YgwFEkNb+1h+8WYBgUm+QlckvHhlAT69TpeYg=";
        aarch64-linux = "sha256-3TkK9YyFtEMpRjG/iKvxctD8pYRh0bWgH+3QWh++r5U=";
        x86_64-darwin = "sha256-bvDZBSQmsXmJA2ZekWPr6krB0KzCFFly8KUqT5mVK1A=";
        aarch64-darwin = "sha256-UybuCXpE/xwg4YmR3rpZiFTs1KQYAttpEjF/Fz+UD00=";
      }
      .${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");
  };

  postInstall = ''
    install -m755 -D vere-v${version}-${platform} $out/bin/urbit
  '';

  passthru.updateScript = ./update-bin.sh;

  meta = with lib; {
    homepage = "https://urbit.org";
    description = "An operating function";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = [ maintainers.matthew-levan ];
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "urbit";
  };
}
