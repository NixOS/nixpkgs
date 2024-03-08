{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "guff";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "silentbicycle";
    repo = "guff";
    rev = "v${version}";
    sha256 = "0n8mc9j3044j4b3vgc94ryd2j9ik6g73fqja54yxfdfrks4ksyds";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  doCheck = true;

  meta = with lib;  {
    description = "A plot device";
    homepage = "https://github.com/silentbicycle/guff";
    license = licenses.isc;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
    mainProgram = "guff";
  };
}
