{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, txt2man
, which
}:

stdenv.mkDerivation rec {
  pname = "retry";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "minfrin";
    repo = "retry";
    rev = "${pname}-${version}";
    hash = "sha256-C6PYt5NjDT4w1yuWnw1+Z/L3j1S5zwTGsI44yrMnPUs=";
  };

  nativeBuildInputs = [ autoreconfHook txt2man which ];

  meta = with lib; {
    homepage = "https://github.com/minfrin/retry";
    description = "Retry a command until the command succeeds";
    license = licenses.asl20;
    maintainers = with maintainers; [ gfrascadorio ];
    platforms = platforms.all;
  };
}

