{ stdenv, fetchFromGitHub, rustPlatform, fetchpatch
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "procs";
  version = "0.8.16";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = pname;
    rev = "v${version}";
    sha256 = "0l4n3gr1sc7wfa21p8yh7idaii0mnfpyqp4cg7f9l4345isy94vq";
  };

  cargoSha256 = "03c63dlzvag341n6la1s61ccri1avlprd91m11z9zzjhi9b46kcr";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  patches = [
    # Fix tests on darwin. Remove with the next release
    (fetchpatch {
      url = "https://github.com/dalance/procs/commit/bb554e247b5b339bc00fa5dd2e771b0d7cb09cd5.patch";
      sha256 = "1szvvifa4pdbgdsmdj5f0zq6qzf1lh6wwc6ipawblfzwmg7d9wvk";
    })
  ];

  meta = with stdenv.lib; {
    description = "A modern replacement for ps written in Rust";
    homepage = "https://github.com/dalance/procs";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.dalance ];
    platforms = with platforms; linux ++ darwin;
  };
}
