{ lib, stdenv, fetchFromGitHub, kernel, bc }:

stdenv.mkDerivation rec {
  pname = "rtl88x2bu";
  version = "${kernel.version}-unstable-2022-12-17";

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "88x2bu-20210702";
    rev = "9a04d2bb9d882c7f2708560774d7b96a70d83f4b";
    sha256 = "sha256-PxTUCYBfyCDB8IjNKsp7aiPtSI3TFzGuJsHqG66e2Q0=";
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
    maintainers = [ maintainers.ralith ];
  };
}
