{ lib, stdenvNoCC, fetchFromGitHub, bash }:

stdenvNoCC.mkDerivation rec {
  pname = "bfetch";
  version = "unstable-2021-05-21";

  src = fetchFromGitHub {
    owner = "NNBnh";
    repo = pname;
    rev = "ef88e9d3f815e5074efc8ef4b7f32be6818130f2";
    sha256 = "sha256-jS9zI8b+z3KbI+LeHFwIMJfEmAKSzO8HRZ2rk35hJCk=";
  };

  buildInputs = [ bash ];

  postPatch = ''
    patchShebangs --host bin/bfetch
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "SuperB general-purpose fetch displayer written in portable sh";
    homepage = "https://github.com/NNBnh/bfetch";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [ moni ];
    mainProgram = "bfetch";
  };
}
