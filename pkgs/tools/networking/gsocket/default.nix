{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "gsocket";
  version = "1.4.41";

  src = fetchFromGitHub {
    owner = "hackerschoice";
    repo = "gsocket";
    rev = "v${version}";
    hash = "sha256-N/dGvEjCkCQvTTWApN0iQi2W3c5ZsaHXnZpjRxSfByY=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ openssl ];
  dontDisableStatic = true;

  meta = with lib; {
    description = "Connect like there is no firewall, securely";
    homepage = "https://www.gsocket.io";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.msm ];
  };
}
