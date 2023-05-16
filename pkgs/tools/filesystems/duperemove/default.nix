{ lib, stdenv, fetchFromGitHub, libgcrypt
<<<<<<< HEAD
, pkg-config, glib, linuxHeaders ? stdenv.cc.libc.linuxHeaders, sqlite
, util-linux }:

stdenv.mkDerivation rec {
  pname = "duperemove";
  version = "0.12";
=======
, pkg-config, glib, linuxHeaders ? stdenv.cc.libc.linuxHeaders, sqlite }:

stdenv.mkDerivation rec {
  pname = "duperemove";
  version = "0.11.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "markfasheh";
    repo = "duperemove";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-VPwcWAENCRnU51F78FhMPjQZaCTewQRUdeFwK1blJbs=";
  };

  postPatch = ''
    substituteInPlace util.c --replace \
      "lscpu" "${lib.getBin util-linux}/bin/lscpu"
  '';

=======
    sha256 = "sha256-WjUM52IqMDvBzeGHo7p4JcvMO5iPWPVOr8GJ3RSsnUs=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libgcrypt glib linuxHeaders sqlite ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "A simple tool for finding duplicated extents and submitting them for deduplication";
    homepage = "https://github.com/markfasheh/duperemove";
    license = licenses.gpl2;
    maintainers = with maintainers; [ bluescreen303 thoughtpolice ];
    platforms = platforms.linux;
  };
}
