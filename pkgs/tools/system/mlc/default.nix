{ lib, stdenv, fetchurl, patchelf }:
stdenv.mkDerivation rec {
  pname = "mlc";
  version = "3.9a";

  src = fetchurl {
    url = "https://downloadmirror.intel.com/736634/mlc_v${version}.tgz";
    sha256 = "3vNI/CQwyY4KMFest1wkVYecsxigjXyGIUIKai979W4=";
  };

  sourceRoot = "Linux";

  installPhase = ''
    install -Dm755 mlc $out/bin/mlc
  '';

  nativeBuildInputs = [ patchelf ];

  fixupPhase = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/mlc
  '';

  meta = with lib; {
    homepage = "https://software.intel.com/content/www/us/en/develop/articles/intelr-memory-latency-checker.html";
    description = "Intel Memory Latency Checker";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ basvandijk ];
    platforms = with platforms; linux;
  };
}
