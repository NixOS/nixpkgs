{ lib, stdenv, fetchFromGitHub
, curl, findutils, gnugrep, gnused, shellcheck }:

let
  pname = "pass-checkup";
  version = "0.2.1";
in stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "etu";
    repo = pname;
    rev = version;
    sha256 = "18b6rx59r7g0hvqs2affvw0g0jyifyzhanwgz2q2b8nhjgqgnar2";
  };

  nativeBuildInputs = [ shellcheck ];

  postPatch = ''
    substituteInPlace checkup.bash \
      --replace curl ${curl}/bin/curl \
      --replace find ${findutils}/bin/find \
      --replace grep ${gnugrep}/bin/grep \
      --replace sed ${gnused}/bin/sed
  '';

  installPhase = ''
    runHook preInstall

    install -D -m755 checkup.bash $out/lib/password-store/extensions/checkup.bash

    runHook postInstall
  '';

  meta = with lib; {
    description = "A pass extension to check against the Have I been pwned API to see if your passwords are publicly leaked or not";
    homepage = "https://github.com/etu/pass-checkup";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ etu ];
    platforms = platforms.unix;
  };
}
