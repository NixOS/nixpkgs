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
  version = "3.10.0";

  src = fetchFromGitHub {
    owner = "Genivia";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ujLKAJNt2bWIq79Wh94QTFpd+7yUMhS7UMXa8gJScA4=";
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
