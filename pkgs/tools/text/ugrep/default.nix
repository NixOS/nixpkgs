{ stdenv, fetchFromGitHub, boost, bzip2, lz4, pcre2, xz, zlib }:

stdenv.mkDerivation rec {
  pname = "ugrep";
  version = "2.5.3";

  src = fetchFromGitHub {
    owner = "Genivia";
    repo = pname;
    rev = "v${version}";
    sha256 = "16ly1dz8wxnjk6kc88dl2x0ijmzw5v87fhai9fnardwfmycn7ivc";
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
