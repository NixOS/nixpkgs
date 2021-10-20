{ lib, stdenv, fetchurl, patchelf }:
stdenv.mkDerivation rec {
  pname = "mlc";
  version = "3.9";

  src = fetchurl {
    url = "https://software.intel.com/content/dam/develop/external/us/en/protected/mlc_v${version}.tgz";
    sha256 = "1x7abm9hbv9hkqa3cgxz6l04m3ycyl40i4zgx1w819pc10n6dhdb";
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
    license = licenses.unfree;
    maintainers = with maintainers; [ basvandijk ];
    platforms = with platforms; linux;
  };
}
