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
  version = "2.9";

  src = fetchzip {
    url = "https://github.com/urbit/vere/releases/download/vere-v${version}/${platform}.tgz";
    sha256 = {
      x86_64-linux = "sha256-CX3KoB5NNZBfikARh0ikeKQocaGIhbWcZsTFWOFk5oI=";
      aarch64-linux = "sha256-PHVh4ktUe2HIPyudiwEUNuAfwOu4yCI9lxgbjrIllSU=";
      x86_64-darwin = "sha256-lACh1UYtGrZUw+dtR0Ye6zqdtgp7llV9EkUoGOi+V4c=";
      aarch64-darwin = "sha256-IRVMIriFVEsv69yUCxsiUaEgIlc618tf9dHiz76D+ug=";
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
