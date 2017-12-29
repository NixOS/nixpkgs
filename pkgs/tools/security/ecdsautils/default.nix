{ stdenv, pkgs }:

stdenv.mkDerivation rec {
  version = "0.4.0";
  name = "ecdsautils-${version}";

  src = pkgs.fetchFromGitHub {
    owner = "tcatm";
    repo = "ecdsautils";
    rev = "07538893fb6c2a9539678c45f9dbbf1e4f222b46";
    sha256 = "18sr8x3qiw8s9l5pfi7r9i3ayplz4jqdml75ga9y933vj7vs0k4d";
  };

  nativeBuildInputs = with pkgs; [ cmake pkgconfig doxygen ];
  buildInputs = with pkgs; [ libuecc  ];

  meta = with stdenv.lib; {
    description = "Tiny collection of programs used for ECDSA (keygen, sign, verify)";
    homepage = https://github.com/tcatm/ecdsautils/;
    license = with licenses; [ mit bsd2 ];
    maintainers = with maintainers; [ andir ];
    platforms = platforms.unix;
  };
}
