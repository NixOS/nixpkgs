{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "2.2.7";
  pname = "discount";

  src = fetchFromGitHub {
    owner = "Orc";
    repo = pname;
    rev = "v${version}";
    sha256 = "0p2gznrsvv82zxbajqir8y2ap1ribbgagqg1bzhv3i81p2byhjh7";
  };

  patches = ./fix-configure-path.patch;
  configureScript = "./configure.sh";

  configureFlags = [
    "--enable-all-features"
    "--pkg-config"
    "--shared"
    "--with-fenced-code"
  ];

  doCheck = true;

  meta = with lib; {
    description = "Implementation of Markdown markup language in C";
    homepage = "http://www.pell.portland.or.us/~orc/Code/discount/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ shell ];
    platforms = platforms.unix;
  };
}
