# auto-generated file -- DO NOT EDIT!
{ stdenv, fetchurl }:

let
  fetch_librusty_v8 = args: fetchurl {
    name = "librusty_v8-${args.version}";
    url = "https://github.com/denoland/rusty_v8/releases/download/v${args.version}/librusty_v8_release_${stdenv.hostPlatform.rust.rustcTarget}.a.gz";
    sha256 = args.shas.${stdenv.hostPlatform.system};
    meta = { inherit (args) version; };
  };
in
fetch_librusty_v8 {
  version = "0.91.0";
  shas = {
    x86_64-linux = "sha256-xLQnHOUuZq24/LhXJ1PgspI/Mpip3XSLMVQE/nh4chE=";
    aarch64-linux = "sha256-zt05idUKlyPuVk8+N219dTfhtlcObO+cBb41Z6TTwfs=";
    x86_64-darwin = "sha256-AFEUZO3aKNy4rEk9Mi611cuduE5p5lkE23RzLOTPP4Q=";
    aarch64-darwin = "sha256-fldGauOMYSwWWP/kF0Ifp5s20h6akbb5sI8iw1hj/6s=";
  };
}
