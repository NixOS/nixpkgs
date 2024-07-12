{ lib, stdenv, fetchFromGitHub, tomb }:

stdenv.mkDerivation rec {
  pname = "pass-tomb";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "roddhjav";
    repo = "pass-tomb";
    rev = "v${version}";
    sha256 = "sha256-kbbMHmYmeyt7HM8YiNhknePm1vUaXWWXPWePKGpbU+o=";
  };

  buildInputs = [ tomb ];

  dontBuild = true;

  installFlags = [ "PREFIX=$(out)" ];

  postFixup = ''
    substituteInPlace $out/lib/password-store/extensions/tomb.bash \
      --replace 'TOMB="''${PASSWORD_STORE_TOMB:-tomb}"' 'TOMB="''${PASSWORD_STORE_TOMB:-${tomb}/bin/tomb}"'
  '';

  meta = with lib; {
    description = "Pass extension that keeps the password store encrypted inside a tomb";
    homepage = "https://github.com/roddhjav/pass-tomb";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ lovek323 fpletz tadfisher ];
    platforms = platforms.unix;
  };
}
