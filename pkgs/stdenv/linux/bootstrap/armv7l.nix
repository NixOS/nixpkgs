{
  busybox = import <nix/fetchurl.nix> {
    url = http://192.168.111.140:8000/busybox;
    sha256 = "18793riwv9r1bgz6zv03c84cd0v26gxsm8wd2c7gjrwwyfg46ls4";
    executable = true;
  };

  bootstrapTools = import <nix/fetchurl.nix> {
    url = http://192.168.111.140:8000/bootstrap-tools.tar.xz;
    sha256 = "1qyp871dajz5mi3yaw9sndwh4yrh1jj184wjjwaf6dpr3jir4kyd";
  };
}
