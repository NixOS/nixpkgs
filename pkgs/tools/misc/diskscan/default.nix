{ stdenv, fetchFromGitHub, cmake, ncurses, zlib }:

stdenv.mkDerivation rec {
  name = "diskscan-${version}";
  version = "0.19";

  src = fetchFromGitHub {
    owner  = "baruch";
    repo   = "diskscan";
    rev    = "${version}";
    sha256 = "0yqpaxfahbjr8hr9xw7nngncwigy7yncdwnyp5wy9s9wdp8mrjra";
  };

  buildInputs = [ ncurses zlib ];

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    homepage = https://github.com/baruch/diskscan;
    description = "Scan HDD/SSD for failed and near failed sectors";
    platforms = with platforms; linux;
    maintainers = with maintainers; [ peterhoeg ];
    inherit version;
  };
}
