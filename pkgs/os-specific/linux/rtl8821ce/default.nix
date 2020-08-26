{ stdenv, fetchFromGitHub, kernel, bc }:
stdenv.mkDerivation rec {
  name = "rtl8821ce-${kernel.version}-${version}";
  version = "5.5.2_34066.20200325";

  src = fetchFromGitHub {
    owner = "tomaspinho";
    repo = "rtl8821ce";
    rev = "8d7edbe6a78fd79cfab85d599dad9dc34138abd1";
    sha256 = "1hsf8lqjnkrkvk0gps8yb3lx72mvws6xbgkbdmgdkz7qdxmha8bp";
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
    description = "Realtek rtl8821ce driver";
    homepage = "https://github.com/tomaspinho/rtl8821ce";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hhm samuelgrf ];
  };
}
