{ stdenv, fetchFromGitHub, kernel, bc }:
stdenv.mkDerivation rec {
  name = "rtl8821ce-${kernel.version}-${version}";
  version = "5.5.2_34066.20200325";

  src = fetchFromGitHub {
    owner = "tomaspinho";
    repo = "rtl8821ce";
    rev = "69765eb288a8dfad3b055b906760b53e02ab1dea";
    sha256 = "17jiw25k74kv5lnvgycvj2g1n06hbrpjz6p4znk4a62g136rhn4s";
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
    maintainers = [ maintainers.hhm ];
  };
}
