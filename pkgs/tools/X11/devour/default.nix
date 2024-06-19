{ lib, stdenv, fetchFromGitHub, libX11 }:

stdenv.mkDerivation rec {
  pname = "devour";
  version = "12";

  src = fetchFromGitHub {
    owner = "salman-abedin";
    repo = "devour";
    rev = version;
    sha256 = "1qq5l6d0fn8azg7sj7a4m2jsmhlpswl5793clcxs1p34vy4wb2lp";
  };

  installPhase = ''
    install -Dm555 -t $out/bin devour
  '';

  buildInputs = [ libX11 ];

  meta = with lib; {
    description = "Devour hides your current window when launching an external program";
    longDescription = "Devour hides your current window before launching an external program and unhides it after quitting";
    homepage = "https://github.com/salman-abedin/devour";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ mazurel ];
    platforms = platforms.unix;
    mainProgram = "devour";
  };
}
