{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "topgrade";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "r-darwish";
    repo = pname;
    rev = "v${version}";
    sha256 = "15w1qi38dsx573nadqpvarxx63xla53w775fwkdds2iyspaljsg6";
  };

  cargoSha256 = "0xhrgs2rpkgjzgsipq5rb3fmqwvxrl2wi0fly1xaa6p304k1710m";

  meta = with stdenv.lib; {
    description = "Upgrade all the things";
    homepage = "https://github.com/r-darwish/topgrade";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ filalex77 ];
  };
}
