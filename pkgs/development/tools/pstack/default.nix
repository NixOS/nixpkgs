{ lib
, stdenv
, fetchFromGitHub
, cmake
, zlib
, xz
}:

stdenv.mkDerivation rec {
  pname = "pstack";
  version = "2.4.6";

  src = fetchFromGitHub {
    owner = "peadar";
    repo = "pstack";
    rev = "v${version}";
    hash = "sha256-eM8zmUUijbhrXt7IhwT+IxNSkfpAUfafS9eFKKvUIYQ=";
  };

  buildInputs = [
    zlib
    xz
  ];

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "Print stack traces from running processes, or core files.";
    homepage = "https://github.com/peadar/pstack";
    changelog = "https://github.com/peadar/pstack/releases/tag/${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mbalatsko ];
    mainProgram = "pstack";
    platforms = platforms.all;
  };
}
