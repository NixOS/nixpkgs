{ lib, stdenv, fetchFromGitHub, libftdi }:

stdenv.mkDerivation rec {
  pname = "infnoise";
  version = "unstable-2019-08-12";

  src = fetchFromGitHub {
    owner = "13-37-org";
    repo = "infnoise";
    rev = "132683d4b5ce0902468b666cba63baea36e97f0c";
    sha256 = "1dzfzinyvhyy9zj32kqkl19fyhih6sy8r5sa3qahbbr4c30k7flp";
  };

  # Patch makefile so we can set defines from the command line instead of it depending on .git
  patches = [ ./makefile.patch ];
  GIT_COMMIT = src.rev;
  GIT_VERSION = version;
  GIT_DATE = "2019-08-12";

  buildInputs = [ libftdi ];

  sourceRoot = "source/software";
  makefile = "Makefile.linux";
  makeFlags = [ "PREFIX=$(out)" ];
  postPatch = ''
    substituteInPlace init_scripts/infnoise.service --replace "/usr/local" "$out"
  '';

  meta = with lib; {
    homepage = "https://github.com/13-37-org/infnoise";
    description = "Driver for the Infinite Noise TRNG";
    longDescription = ''
      The Infinite Noise TRNG is a USB key hardware true random number generator.
      It can either provide rng for userland applications, or provide rng for the OS entropy.
      Add the following to your system configuration for plug and play support, adding to the OS entropy:
      systemd.packages = [ pkgs.infnoise ];
      services.udev.packages = [ pkgs.infnoise ];
    '';
    license = licenses.cc0;
    maintainers = with maintainers; [ StijnDW ];
    platforms = platforms.linux;
  };
}
