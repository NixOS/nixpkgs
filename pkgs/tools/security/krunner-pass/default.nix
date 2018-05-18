{ mkDerivation, stdenv,
  fetchFromGitHub,
  cmake, extra-cmake-modules, gnumake,

  pass, pass-otp ? null, krunner,
}:
let
  pname = "krunner-pass";
  version = "1.3.0";
in
mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "akermu";
    repo = "krunner-pass";
    rev = "v${version}";
    sha256 = "032fs2174ls545kjixbhzyd65wgxkw4s5vg8b20irc5c9ak3pxm0";
  };

  buildInputs  = [
    pass
    pass-otp
    krunner
  ];

  nativeBuildInputs = [cmake extra-cmake-modules gnumake];

  patches = [
    ./pass-path.patch
  ];

  CXXFLAGS = [
    ''-DNIXPKGS_PASS=\"${stdenv.lib.getBin pass}/bin/pass\"''
  ];

  meta = with stdenv.lib; {
    description = "Integrates krunner with pass the unix standard password manager (https://www.passwordstore.org/)";
    homepage = https://github.com/akermu/krunner-pass;
    license = licenses.gpl3;
    maintainers = with maintainers; [ ysndr ];
    platforms = platforms.unix;
  };
}
