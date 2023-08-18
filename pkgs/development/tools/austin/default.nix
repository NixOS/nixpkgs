{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, python310
}:

stdenv.mkDerivation rec {
  pname = "austin";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "P403n1x87";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Wfw6xSIlOqvIdgN3WQqvB3A6jWM2Ba6NtDEUeB4eHos=";
  };

  nativeBuildInputs = [
    autoreconfHook
    python310
  ];
  strictDeps = true;

  # test/__init__.py requests support of the pattern matching, valid only in
  # python 3.10
  checkInputs = [
    python310.pkgs.flaky
    python310.pkgs.pytestCheckHook
  ];
  doCheck = true;

  meta = with lib; {
    description = "Python frame stack sampler for CPython";
    homepage = "https://github.com/P403n1x87/austin";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ net-mist ];
  };
}
