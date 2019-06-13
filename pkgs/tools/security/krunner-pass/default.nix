{ mkDerivation, lib, fetchFromGitHub, fetchpatch, cmake, extra-cmake-modules
, kauth, krunner
, pass, pass-otp ? null }:

mkDerivation rec {
  pname = "krunner-pass";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "akermu";
    repo = "krunner-pass";
    rev = "v${version}";
    sha256 = "032fs2174ls545kjixbhzyd65wgxkw4s5vg8b20irc5c9ak3pxm0";
  };

  buildInputs  = [
    kauth krunner
    pass pass-otp
  ];

  nativeBuildInputs = [ cmake extra-cmake-modules ];

  patches = [
    (fetchpatch {
      url = https://github.com/peterhoeg/krunner-pass/commit/be2695f4ae74b0cccec8294defcc92758583d96b.patch;
      sha256 = "098dqnal57994p51p2srfzg4lgcd6ybp29h037llr9cdv02hdxvl";
      name = "fix_build.patch";
    })
    ./pass-path.patch
  ];

  CXXFLAGS = [
    ''-DNIXPKGS_PASS=\"${lib.getBin pass}/bin/pass\"''
  ];

  meta = with lib; {
    description = "Integrates krunner with pass the unix standard password manager (https://www.passwordstore.org/)";
    homepage = https://github.com/akermu/krunner-pass;
    license = licenses.gpl3;
    maintainers = with maintainers; [ ysndr ];
    platforms = platforms.unix;
  };
}
