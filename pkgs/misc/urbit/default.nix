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
  version = "1.20";

  src = fetchzip {
    url = "https://github.com/urbit/vere/releases/download/vere-v${version}/${platform}.tgz";
    sha256 = {
      x86_64-linux = "sha256-nBIpf9akK4cXnR5y5Fcl1g7/FxL8BU/CH/WHGhYuP74=";
      aarch64-linux = "sha256-ERSYXNh/vmAKr4PNonOxTm5/FRLNDWwHSHM6fIeY4Nc=";
      x86_64-darwin = "sha256-Kk9hNzyWngnyqlyQ9hILFM81WVw1ZYimMj4K3ENtifE=";
      aarch64-darwin = "sha256-i3ixj04J/fcb396ncINLF8eYw1mpFCYeIM3f74K6tqY=";
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
