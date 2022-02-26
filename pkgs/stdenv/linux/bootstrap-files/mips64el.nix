{
  busybox = import <nix/fetchurl.nix> {
    url = "file:///nix/store/5xy00yds18lycmcm3qzwaxpybqkhbyx9-stdenv-bootstrap-tools-mips64el-linux-gnuabi64/on-server/busybox";
    sha256 = "sha256-0K3Cz+uoG3J8Lfjz8i7NTFujnyKklp9d+NBnLPFAH0I=";
    executable = true;
  };

  bootstrapTools = import <nix/fetchurl.nix> {
    url = "file:///nix/store/5xy00yds18lycmcm3qzwaxpybqkhbyx9-stdenv-bootstrap-tools-mips64el-linux-gnuabi64/on-server/bootstrap-tools.tar.xz";
    sha256 = "sha256-So+8RJ+omB9V2I46Z/sbHiFsOVTW4wIscYr3SXxVz8o=";
  };
}
