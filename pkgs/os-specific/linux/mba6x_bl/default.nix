{ fetchFromGitHub, kernel, lib, stdenv }:

stdenv.mkDerivation {
  pname = "mba6x_bl";
<<<<<<< HEAD
  version = "unstable-2017-12-30";
=======
  version = "unstable-2016-12-08";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "patjak";
    repo = "mba6x_bl";
<<<<<<< HEAD
    rev = "639719f516b664051929c2c0c1140ea4bf30ce81";
    sha256 = "sha256-QwxBpNa5FitKO+2ne54IIcRgwVYeNSQWI4f2hPPB8ls=";
=======
    rev = "b96aafd30c18200b4ad1f6eb995bc19200f60c47";
    sha256 = "10payvfxahazdxisch4wm29fhl8y07ki72q4c78sl4rn73sj6yjq";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  enableParallelBuilding = true;
  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];

  meta = with lib; {
    description = "MacBook Air 6,1 and 6,2 (mid 2013) backlight driver";
    homepage = "https://github.com/patjak/mba6x_bl";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.simonvandel ];
  };
}
