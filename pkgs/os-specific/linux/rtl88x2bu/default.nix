{ lib, stdenv, fetchFromGitHub, kernel, bc }:

<<<<<<< HEAD
stdenv.mkDerivation {
  pname = "rtl88x2bu";
  version = "${kernel.version}-unstable-2023-07-23";
=======
stdenv.mkDerivation rec {
  pname = "rtl88x2bu";
  version = "${kernel.version}-unstable-2023-03-17";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "88x2bu-20210702";
<<<<<<< HEAD
    rev = "83db18e610845df9434a628ca3feb9004296b307";
    sha256 = "sha256-as3S7WQkug3suJ5ovUbRu/UzO5GDrGLdgkiWrCrvztk=";
=======
    rev = "f0a2c9c74045cf2c3701084f389e358f9236fc8c";
    sha256 = "sha256-hquLmEOzdBQ6rJld5kkzVw+hXBFb/ZwpBI0eL0rUrkM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = [ bc ] ++ kernel.moduleBuildDependencies;
  makeFlags = kernel.makeFlags;

  prePatch = ''
    substituteInPlace ./Makefile \
      --replace /lib/modules/ "${kernel.dev}/lib/modules/" \
      --replace /sbin/depmod \# \
      --replace '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Realtek rtl88x2bu driver";
    homepage = "https://github.com/morrownr/88x2bu-20210702";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
<<<<<<< HEAD
    maintainers = with maintainers; [ otavio ];
=======
    maintainers = with maintainers; [ otavio ralith ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
