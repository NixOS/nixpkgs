{ lib, stdenv, fetchFromGitHub, kernel, bc }:

stdenv.mkDerivation rec {
  name = "rtl88x2bu-${kernel.version}-${version}";
  version = "unstable-2021-01-21";

  src = fetchFromGitHub {
    owner = "cilynx";
    repo = "rtl88x2BU";
    rev = "48e7c19c92a77554403e1347447f8e2cfd780228";
    sha256 = "0nw2kgblpq6qlr43gbfxqvq0c83664f4czfwzsyfjr47rj00iyq7";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = [ bc ];
  buildInputs = kernel.moduleBuildDependencies;

  prePatch = ''
    substituteInPlace ./Makefile \
      --replace /lib/modules/ "${kernel.dev}/lib/modules/" \
      --replace '$(shell uname -r)' "${kernel.modDirVersion}" \
      --replace /sbin/depmod \# \
      --replace '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  meta = with lib; {
    description = "Realtek rtl88x2bu driver";
    homepage = "https://github.com/cilynx/rtl88x2bu";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.ralith ];
  };
}
