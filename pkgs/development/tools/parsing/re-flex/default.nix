{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, boost
, autoconf
, automake
}:

stdenv.mkDerivation rec {
  pname = "re-flex";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "Genivia";
    repo = "RE-flex";
    rev = "v${version}";
    sha256 = "sha256-eQ2+RthvOKCd2Dl6i+9DahJArFfOhPJkn6PI/yuaqos=";
  };

  nativeBuildInputs = [ boost autoconf automake ];

  meta = with lib; {
    homepage = "https://github.com/Genivia/RE-flex";
    description = "The regex-centric, fast lexical analyzer generator for C++ with full Unicode support";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with lib.maintainers; [ prrlvr ];
  };
}
