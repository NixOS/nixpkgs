{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "shell-mommy";
  version = "unstable-2023-03-08";

  src = fetchFromGitHub {
    owner = "sudofox";
    repo = pname;
    rev = "0c4d87ede2da93b65c990c18b9ab2d0b357f15f0";
    hash = "sha256-9bW0n7qOETMY8GrOdaCgpZtPWaE6O040U91Ts42cut4=";
  };

  installPhase = ''
    install -Dt $out/bin shell-mommy.sh
  '';

  meta = with lib; {
    homepage = "https://github.com/sudofox/shell-mommy";
    description = "Mommy is here for you on the command line ~ heart";
    license = "";
    maintainers = with maintainers; [ ];
  };
}
