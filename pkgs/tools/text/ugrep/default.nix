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
  version = "3.12.1";

  src = fetchFromGitHub {
    owner = "Genivia";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-kpLzv8nHye1XStHABmZHXQ2Gn+g06BFeN3u47bkKbzU=";
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
    changelog = "https://github.com/Genivia/ugrep/releases/tag/v${version}";
    maintainers = with maintainers; [ numkem ];
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
