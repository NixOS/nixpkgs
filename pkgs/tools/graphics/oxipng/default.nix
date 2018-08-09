{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  version = "2.1.0";
  name = "oxipng-${version}";

  src = fetchFromGitHub {
    owner = "shssoichiro";
    repo = "oxipng";
    rev = "v${version}";
    sha256 = "13rzkfb025y4i9dj66fgc74whgs90gyw861dccsj16cpfl6kh5z0";
  };

  cargoSha256 = "0l6ad8rnifd5hkv6x2cr0frdddsfwm1xd1v56imlglsjkgz56cva";

  meta = with stdenv.lib; {
    homepage = https://github.com/shssoichiro/oxipng;
    description = "A lossless PNG compression optimizer";
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.all;

    # macro is_arm_feature_detected! is unstable
    broken = stdenv.isAarch64;
  };
}
