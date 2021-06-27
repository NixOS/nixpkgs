{ lib, stdenv, fetchFromGitHub, autoreconfHook
, freeimage, libGL }:

stdenv.mkDerivation rec {
  version = "1.0.4";
  pname = "gamecube-tools";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ freeimage libGL ];

  src = fetchFromGitHub {
    owner = "devkitPro";
    repo  = "gamecube-tools";
    rev = "v${version}";
    sha256 = "sha256-0iMY2LokfsYgHzIuFc8RlrVlJCURqVqprP54PG4oW0M=";
  };

  meta = with lib; {
    description = "Tools for gamecube/wii projects";
    homepage = "https://github.com/devkitPro/gamecube-tools/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ tomsmeets ];
  };
}
