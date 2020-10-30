{ stdenv, fetchFromGitHub, fetchpatch, kernel, bc }:

stdenv.mkDerivation rec {
  name = "rtl88x2bu-${kernel.version}-${version}";
  version = "unstable-2020-08-20";

  src = fetchFromGitHub {
    owner = "cilynx";
    repo = "rtl88x2BU";
    rev = "a1c53f43fb9995fbe3ad26567079d6384626d350";
    sha256 = "1cby66jg511zxs1i535mflafhryla9764mnrzacxppimxpancv3s";
  };

  patches = [
    # https://github.com/cilynx/rtl88x2bu/pull/58
    (fetchpatch {
      url = "https://github.com/cilynx/rtl88x2bu/pull/58.patch";
      sha256 = "0md9cv61nx85pk3v60y9wviyb9fgj54q9m26wiv3dc7smr70h8l6";
    })
  ];

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
