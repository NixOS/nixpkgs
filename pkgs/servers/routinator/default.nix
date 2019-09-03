{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "routinator";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "075dp092pgwnky96smv5v6sx9vj7hd5bif8rb1q4x6077ci5jixw";
  };

  cargoSha256 = "0qxp3pjmrr53n59c2wcdnbqgk259zcj9gd11wpqf7kj3wlzrnwvy";

  meta = with stdenv.lib; {
    description = "An RPKI Validator written in Rust";
    homepage = "https://github.com/NLnetLabs/routinator";
    license = licenses.bsd3;
    maintainers = [ maintainers."0x4A6F" ];
    platforms = platforms.linux;
  };
}
