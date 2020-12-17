{ stdenv, fetchFromGitHub, boost, bzip2, lz4, pcre2, xz, zlib }:

stdenv.mkDerivation rec {
  pname = "ugrep";
  version = "3.0.6";

  src = fetchFromGitHub {
    owner = "Genivia";
    repo = pname;
    rev = "v${version}";
    sha256 = "1s8glpk7li45rcf2xi21qv65dldl8sd3mmalf54pbzfcjri5fwz6";
  };

  buildInputs = [ boost bzip2 lz4 pcre2 xz zlib ];

  meta = with stdenv.lib; {
    description = "Ultra fast grep with interactive query UI";
    homepage = "https://github.com/Genivia/ugrep";
    maintainers = with maintainers; [ numkem ];
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
