{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "tokei-${version}";
  version = "6.1.2";

  src = fetchFromGitHub {
    owner = "Aaronepower";
    repo = "tokei";
    rev = "v${version}";
    sha256 = "1bzs3mr6f9bna39b9ddwwq0raas07nbn106mnq3widxg59i0gxhd";
  };

  cargoSha256 = "0y0rkxhkv31v5sa0425dwskd80i6srwbqhqkrw1g1kbmbs9y0vxz";

  buildPhase = ''
    # do not pass --frozen since Cargo.lock has the wrong tokei version
    cargo build --release
  '';

  meta = with stdenv.lib; {
    description = "Count code, quickly";
    homepage = https://github.com/Aaronepower/tokei;
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
    platforms = platforms.all;
  };
}
