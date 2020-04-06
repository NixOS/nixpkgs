{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "2.2.6";
  pname = "discount";

  src = fetchFromGitHub {
    owner = "Orc";
    repo = pname;
    rev = "v${version}";
    sha256 = "1y066jkxfas0vdixbqq66j9p00a102sbfgq5gbrblfczqjrmc38w";
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

  meta = with stdenv.lib; {
    description = "Implementation of Markdown markup language in C";
    homepage = http://www.pell.portland.or.us/~orc/Code/discount/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ shell ];
    platforms = platforms.unix;
  };
}
