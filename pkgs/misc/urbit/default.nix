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
  version = "1.21";

  src = fetchzip {
    url = "https://github.com/urbit/vere/releases/download/vere-v${version}/${platform}.tgz";
    sha256 = {
      x86_64-linux = "sha256-zHxISUJo2Li1PRjGC9LLXsDhLOHeuYejC+IM+9uDSks=";
      aarch64-linux = "sha256-6gVuACG+/XJrYNjxJ2FxtkaEJuI2Sd8uM2Tgt4vbgkQ=";
      x86_64-darwin = "sha256-BVDGdueu18HzL9FmaJniQp+OLQAVpSYYxxyvjlHFv3I=";
      aarch64-darwin = "sha256-kwRezLpi5AEyAQ+Kyd992fpCerunaHOzRB4Wvb3dlY0=";
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
