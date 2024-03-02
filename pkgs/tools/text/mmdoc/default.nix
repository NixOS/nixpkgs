{ lib
, stdenv
, fetchFromGitHub
, cmark-gfm
, xxd
, fastJson
, libzip
, ninja
, meson
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "mmdoc";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "ryantm";
    repo = "mmdoc";
    rev = version;
    hash = "sha256-NS8i5xvCwq0pSdfxnaxnpuwmDAkfH6Tkc4N2F6aGvWY=";
  };

  nativeBuildInputs = [ ninja meson pkg-config xxd ];

  buildInputs = [ cmark-gfm fastJson libzip ];

  meta = with lib; {
    description = "Minimal Markdown Documentation";
    homepage = "https://github.com/ryantm/mmdoc";
    license = licenses.cc0;
    maintainers = with maintainers; [ ryantm ];
    platforms = platforms.unix;
  };
}
