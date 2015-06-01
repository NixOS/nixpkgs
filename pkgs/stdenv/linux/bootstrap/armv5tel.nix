{
  busybox = import <nix/fetchurl.nix> {
    url = "https://www.dropbox.com/s/j8czx0avy9phrbc/busybox?dl=1";
    sha256 = "1czw6hsh8dcqkvahwr73g3yg2g9wyc2v62fpz3ikfgnlnma4v9pk";
    executable = true;
  };

  bootstrapTools = import <nix/fetchurl.nix> {
    url = "https://www.dropbox.com/s/hll4bt74tyscro0/bootstrap-tools.tar.xz?dl=1";
    sha256 = "d9a207ce74c3e05d71b6bbbf9a045b2af3c53b4f33e708a6869fbc011723f3c1";
  };
}
