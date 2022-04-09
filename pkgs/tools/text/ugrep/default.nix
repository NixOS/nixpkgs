{ lib
, stdenv
, fetchFromGitHub
, boost
, bzip2
, lz4
, pcre2
, xz
, zlib
}:

stdenv.mkDerivation rec {
  pname = "ugrep";
  version = "3.7.7";

  src = fetchFromGitHub {
    owner = "Genivia";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FucHivUd9WVQlTsBJbnSd2Q6WQpoFjm6dS0eb6z8SSs=";
  };

  buildInputs = [
    boost
    bzip2
    lz4
    pcre2
    xz
    zlib
  ];

  meta = with lib; {
    description = "Ultra fast grep with interactive query UI";
    homepage = "https://github.com/Genivia/ugrep";
    maintainers = with maintainers; [ numkem ];
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
