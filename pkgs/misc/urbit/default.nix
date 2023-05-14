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
  version = "2.5";

  src = fetchzip {
    url = "https://github.com/urbit/vere/releases/download/vere-v${version}/${platform}.tgz";
    sha256 = {
      x86_64-linux = "sha256-1Qd+bDrmsEQTYaJt1Na4FLWwA+lNib8M5j9c9Mr7hlU=";
      aarch64-linux = "sha256-kFCi5sbnlBRFsdqiqMJ3RaNg2PWEcU2D1JNbE5cNUrA=";
      x86_64-darwin = "sha256-Cp3q1npTSQIZyedXitNt/djFk3Nu8KDM/qzfhl+3i/o=";
      aarch64-darwin = "sha256-KhI0okRUEYa46z/prAIYxmj+BsjhExXm+2+rTnDQkg0=";
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
  };
}
