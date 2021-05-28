{ stdenv, fetchFromGitHub, kernel, bc }:
stdenv.mkDerivation rec {
  name = "rtl8821cu-${kernel.version}-${version}";
  version = "unstable-2020-08-21";

  src = fetchFromGitHub {
    owner = "brektrou";
    repo = "rtl8821cu";
    rev = "45a8b4393e3281b969822c81bd93bdb731d58472";
    sha256 = "1995zs1hvlxjhbh2w7zkwr824z19cgc91s00g7yhm5d7zjav14rd";
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

  meta = with stdenv.lib; {
    description = "Realtek rtl8821cu driver";
    homepage = "https://github.com/brektrou/rtl8821CU";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.contrun ];
  };
}
