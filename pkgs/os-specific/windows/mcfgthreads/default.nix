{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "mcfgthread";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "lhmouse";
    repo = "mcfgthread";
    rev = "v${lib.versions.majorMinor version}-ga.${lib.versions.patch version}";
    hash = "sha256-FrmeaQhwLrNewS0HDlbWgCvVQ5U1l0jrw0YVuQdt9Ck=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    description = "Threading support library for Windows 7 and above";
    homepage = "https://github.com/lhmouse/mcfgthread/wiki";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ wegank ];
    platforms = lib.platforms.windows;
  };
}
