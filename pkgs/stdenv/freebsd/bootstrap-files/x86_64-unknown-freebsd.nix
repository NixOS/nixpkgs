{
  unpack = import <nix/fetchurl.nix> {
    url = "http://192.168.122.1:8000/result/on-server/unpack.nar.xz";
    hash = "sha256-y6quCU9JKnKBdHDcUkdkM0ypWDT2cdSiqR1WqA+8ozE=";
    name = "boostrapUnpacked";
    unpack = true;
  };
  bootstrapTools = import <nix/fetchurl.nix> {
    url = "http://192.168.122.1:8000/result/on-server/bootstrap-tools.tar.xz";
    hash = "sha256-ypIOxsB8a/RPupki0ZTjb+vuE+ibtmS8e3DazeolHj8=";
    name = "bootstrapTools.tar.xz";
  };
}
