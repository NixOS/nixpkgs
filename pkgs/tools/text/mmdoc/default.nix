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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "ryantm";
    repo = "mmdoc";
    rev = version;
    hash = "sha256-MZdLEdcNLUYWWyHb3qjNyi7MUwiqm3dNLHIb+VKqUcQ=";
  };

  nativeBuildInputs = [ ninja meson pkg-config ];

  buildInputs = [ cmark-gfm fastJson xxd libzip.dev ];

  doCheck = true;

  meta = with lib; {
    description = "Minimal Markdown Documentation";
    homepage = src.meta.homepage;
    license = licenses.cc0;
    maintainers = with maintainers; [ ryantm ];
    platforms = platforms.unix;
  };

}
