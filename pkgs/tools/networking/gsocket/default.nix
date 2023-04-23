{ lib, stdenv, fetchFromGitHub, autoreconfHook, openssl }:

stdenv.mkDerivation rec {
  pname = "gsocket";
  version = "1.4.39";

  src = fetchFromGitHub {
    owner = "hackerschoice";
    repo = "gsocket";
    rev = "v${version}";
    sha256 = "sha256-iSII21X3F4Cb1UqF0aYw23N7CyeTQMmziRioEULx9Zk=";
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
