{ stdenv, fetchFromGitHub
, curl, findutils, gnugrep, gnused }:

stdenv.mkDerivation rec {
  pname = "pass-checkup";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "etu";
    repo = "pass-checkup";
    rev = version;
    sha256 = "17fyf8zj535fg43yddjww1jhxfb3nbdkn622wjxaai2nf46jzh7y";
  };

  patchPhase = ''
    substituteInPlace checkup.bash \
      --replace curl ${curl}/bin/curl \
      --replace find ${findutils}/bin/find \
      --replace grep ${gnugrep}/bin/grep \
      --replace sed ${gnused}/bin/sed
  '';

  installPhase = ''
    install -D -m755 checkup.bash $out/lib/password-store/extensions/checkup.bash
  '';

  meta = with stdenv.lib; {
    description = "A pass extension to check against the Have I been pwned API to see if your passwords are publicly leaked or not";
    homepage = "https://github.com/etu/pass-checkup";
    license = licenses.gpl3;
    maintainers = with maintainers; [ etu ];
    platforms = platforms.unix;
  };
}
