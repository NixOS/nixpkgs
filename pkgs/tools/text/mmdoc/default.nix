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
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "ryantm";
    repo = "mmdoc";
    rev = version;
    hash = "sha256-c2YwlvJQfVRjldzfOjTSztIUg64GWq+5ijkFxp4qA8I=";
  };

  nativeBuildInputs = [ ninja meson pkg-config xxd ];

  buildInputs = [ cmark-gfm fastJson libzip ];

  doCheck = stdenv.isx86_64;

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Minimal Markdown Documentation";
    homepage = "https://github.com/ryantm/mmdoc";
    license = licenses.cc0;
    maintainers = with maintainers; [ ryantm ];
    platforms = platforms.unix;
  };
}
