{
  busybox = import <nix/fetchurl.nix> {
    url = https://dl.dropboxusercontent.com/s/rowzme529tc5svq/busybox?dl=0;
    sha256 = "18793riwv9r1bgz6zv03c84cd0v26gxsm8wd2c7gjrwwyfg46ls4";
    executable = true;
  };

  bootstrapTools = import <nix/fetchurl.nix> {
    url = https://dl.dropboxusercontent.com/s/3jr4s5449t7zjlj/bootstrap-tools.tar.xz?dl=0;
    sha256 = "1qyp871dajz5mi3yaw9sndwh4yrh1jj184wjjwaf6dpr3jir4kyd";
  };
}
