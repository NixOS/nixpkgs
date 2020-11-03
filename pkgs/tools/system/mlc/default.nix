{ stdenv, fetchurl, patchelf, lib }:
stdenv.mkDerivation rec {
  pname = "mlc";
  version = "3.9";

  src = fetchurl {
    url = "https://software.intel.com/content/dam/develop/external/us/en/protected/mlc_v${version}.tgz";
    sha256 = "1x7abm9hbv9hkqa3cgxz6l04m3ycyl40i4zgx1w819pc10n6dhdb";
  };

  sourceRoot = "Linux";

  nativeBuildInputs = [ patchelf ];

  phases = [ "unpackPhase" "installPhase" "patchPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cp mlc $out/bin/mlc
    chmod +x $out/bin/mlc
  '';

  patchPhase = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/bin/mlc
  '';

  meta = {
    homepage = "https://software.intel.com/content/www/us/en/develop/articles/intelr-memory-latency-checker.html";
    description = "Intel Memory Latency Checker";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ basvandijk ];
    platforms = with lib.platforms; linux;
  };
}
