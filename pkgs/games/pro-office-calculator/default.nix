{ stdenv, fetchFromGitHub, tinyxml-2, cmake, qtbase, qtmultimedia, fetchpatch }:
stdenv.mkDerivation rec {
  version = "1.0.6";
  name = "pro-office-calculator-${version}";

  src = fetchFromGitHub {
    owner  = "RobJinman";
    repo   = "pro_office_calc";
    rev    = "v${version}";
    sha256 = "1irgch6cbc2f8il1zh8qf98m43h41hma80dxzz9c7xvbvl99lybd";
  };

  buildInputs = [ qtbase qtmultimedia tinyxml-2 ];

  # This fixes a bug resulting in "illegal instruction"
  patches = [(fetchpatch {
    url = https://github.com/RobJinman/pro_office_calc/commit/806180d69d4af6b3183873f471c57bfdaf529560.patch;
    sha256 = "1rcdjy233yf3kv4v18c82jyg08dykj2qspvg08n5b3bir870sbxz";
  })];

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "Just an ordinary calculator. Nothing to see here...";
    homepage = http://proofficecalculator.com/;
    maintainers = [ maintainers.pmiddend ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
