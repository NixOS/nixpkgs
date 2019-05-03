{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "fritzbox-exporter-${version}";
  version = "v1.0-32-g90fc0c5";
  rev = "90fc0c572d3340803f7c2aafc4b097db7af1f871";

  src = fetchFromGitHub {
    inherit rev;
    owner = "mxschmitt";
    repo = "fritzbox_exporter";
    sha256 = "08gcc60g187x1d14vh7n7s52zkqgj3fvg5v84i6dw55rmb6zzxri";
  };

  goPackagePath = "github.com/mxschmitt/fritzbox_exporter";

  goDeps = ./fritzbox-exporter-deps.nix;

  meta = with stdenv.lib; {
    description = "Prometheus Exporter for FRITZ!Box (TR64 and UPnP)";
    homepage = https://github.com/ndecker/fritzbox_exporter;
    license = licenses.asl20;
    maintainers = with maintainers; [ bachp flokli ];
    platforms = platforms.unix;
  };
}
