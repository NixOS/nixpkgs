{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, libdrm
}:

stdenv.mkDerivation rec {
  pname = "memreserver";
  version = "unstable-2023-04-01";

  src = fetchFromGitLab {
    domain = "git.dolansoft.org";
    owner = "lorenz";
    repo = pname;
    rev = "480253e565dab935df1d1c4e615ebc8a8dc81ba4";
    hash = "sha256-HjcrH98hH2zKdsHolYCFugL39sT1VjroVhRf8a8dpIA=";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [ libdrm ];

  meta = with lib; {
    homepage = "https://git.dolansoft.org/lorenz/memreserver";
    description = "Sleep hook which frees up RAM needed to evacuate GPU VRAM into";
    license = licenses.mit;
    maintainers = with maintainers; [ lorenz ];
  };
}

