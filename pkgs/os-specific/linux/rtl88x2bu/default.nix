{ stdenv, fetchFromGitHub, kernel, bc }:

stdenv.mkDerivation rec {
  name = "rtl88x2bu-${kernel.version}-${version}";
  version = "unstable-2020-05-19";

  src = fetchFromGitHub {
    owner = "cilynx";
    repo = "rtl88x2BU";
    rev = "0f159d7cd937a12b818121cb1f1c4910bd1adc72";
    sha256 = "0flqnvzfdb4wsiiqv9vf5gfwd5fgpjvhs9zhqknnv1cmp8msgw6y";
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
    description = "Realtek rtl88x2bu driver";
    homepage = "https://github.com/cilynx/rtl88x2bu";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.ralith ];
  };
}
