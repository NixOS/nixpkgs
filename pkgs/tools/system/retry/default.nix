{ lib, stdenv, fetchFromGitHub, autoreconfHook, which, txt2man }:
stdenv.mkDerivation rec {
  pname = "retry";
  version = "1.0.4";

  nativeBuildInputs = [ autoreconfHook which txt2man ];

  src = fetchFromGitHub {
    owner = "minfrin";
    repo = "retry";
    rev = "${pname}-${version}";
    sha256 = "sha256:0jrx4yrwlf4fn3309kxraj7zgwk7gq6rz5ibswq3w3b3jfvxi8qb";
  };

  meta = with lib; {
    homepage = "https://github.com/minfrin/retry";
    description = "Retry a command until the command succeeds";
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = with maintainers; [ gfrascadorio ];
  };
}

