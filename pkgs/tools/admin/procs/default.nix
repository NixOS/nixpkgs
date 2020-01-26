{ stdenv, fetchFromGitHub, rustPlatform, fetchpatch
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "procs";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = pname;
    rev = "v${version}";
    sha256 = "1lprxfy733rs39fg8yif3p8vz9szk7d529ahn1kn70zm8i3mqpch";
  };

  cargoSha256 = "11l2dggvkk2vx4xap2q02qrr576i4mswf67plhg23azr43fpi0r5";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  meta = with stdenv.lib; {
    description = "A modern replacement for ps written in Rust";
    homepage = "https://github.com/dalance/procs";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.dalance ];
    platforms = with platforms; linux ++ darwin;
  };
}
