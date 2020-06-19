{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "routinator";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "12fgvalv12v8690pxmsdg179r170d4mc1kynsb25fm0zggy838jn";
  };

  cargoSha256 = "01118mnb5gm0xqi2c8jj3fk8y55jnnyg9zgn2g4xn7f3i8dcczka";

  meta = with stdenv.lib; {
    description = "An RPKI Validator written in Rust";
    homepage = "https://github.com/NLnetLabs/routinator";
    license = licenses.bsd3;
    maintainers = [ maintainers."0x4A6F" ];
    platforms = platforms.linux;
  };
}
