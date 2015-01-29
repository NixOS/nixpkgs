{
  busybox = import <nix/fetchurl.nix> {
    url = http://192.168.111.140:8000/busybox;
    sha256 = "032maafy4akcdgccpxdxrza29pkcpm81g8kh1hv8bj2rvssly3z2";
    executable = true;
  };

  bootstrapTools = import <nix/fetchurl.nix> {
    url = http://192.168.111.140:8000/bootstrap-tools.tar.xz;
    sha256 = "1474yz6qw1xnnbbkjxk2588c601rzwr08w5sgcliqydyr6kl830j";
  };
}
