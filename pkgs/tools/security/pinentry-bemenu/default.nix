{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config, libassuan
, libgpg-error, popt, bemenu }:

stdenv.mkDerivation rec {
  pname = "pinentry-bemenu";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "t-8ch";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jt7G/OuXqJdnkW7sMNH0o+CI3noDK6EcbOLXq0JoDTk=";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [ libassuan libgpg-error popt bemenu ];

  meta = with lib; {
    description = "Pinentry implementation based on bemenu";
    homepage = "https://github.com/t-8ch/pinentry-bemenu";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jc ];
    platforms = with platforms; linux;
  };
}
