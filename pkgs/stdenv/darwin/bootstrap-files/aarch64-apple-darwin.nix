let
  fetch = { file, sha256, executable ? true }: import <nix/fetchurl.nix> {
    url = "http://tarballs.nixos.org/stdenv-darwin/aarch64/20acd4c4f14040485f40e55c0a76c186aa8ca4f3/${file}";
    inherit sha256 executable;
  }; in
{
  sh = fetch { file = "sh"; sha256 = "17m3xrlbl99j3vm7rzz3ghb47094dyddrbvs2a6jalczvmx7spnj"; };
  bzip2 = fetch { file = "bzip2"; sha256 = "1khs8s5klf76plhlvlc1ma838r8pc1qigk9f5bdycwgbn0nx240q"; };
  mkdir = fetch { file = "mkdir"; sha256 = "1m9nk90paazl93v43myv2ay68c1arz39pqr7lk5ddbgb177hgg8a"; };
  cpio = fetch { file = "cpio"; sha256 = "17pxq61yjjvyd738fy9f392hc9cfzkl612sdr9rxr3v0dgvm8y09"; };
  tarball = fetch { file = "bootstrap-tools.cpio.bz2"; sha256 = "1v2332k33akm6mrm4bj749rxnnmc2pkbgcslmd0bbkf76bz2ildy"; executable = false; };
}
