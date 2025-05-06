{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "space2meta";
  version = "0.2.0";

  src = fetchFromGitLab {
    group = "interception";
    owner = "linux/plugins";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-MvpIe230I0TNzTO6ol1+DrpcFgqw0gF9Z22WMQLujb4=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://gitlab.com/interception/linux/plugins/space2meta";
    description = "Turn your space key into the meta key (a.k.a. win key, OS key, super key) when chorded to another key (on key release only).";
    mainProgram = "space2meta";
    license = licenses.mit;
    maintainers = [ maintainers.vyp ];
    platforms = platforms.linux;
  };
}
