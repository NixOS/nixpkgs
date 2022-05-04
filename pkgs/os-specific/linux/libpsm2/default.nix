{ lib, stdenv, fetchFromGitHub, numactl, pkg-config }:

stdenv.mkDerivation rec {
  pname = "libpsm2";
  version = "11.2.206";

  preConfigure= ''
    export UDEVDIR=$out/etc/udev
    substituteInPlace ./Makefile --replace "udevrulesdir}" "prefix}/etc/udev";
  '';

  enableParallelBuilding = true;

  buildInputs = [ numactl pkg-config ];

  makeFlags = [
    # Disable blanket -Werror to avoid build failures
    # on fresh toolchains like gcc-11.
    "WERROR="
  ];

  installFlags = [
    "DESTDIR=$(out)"
    "UDEVDIR=/etc/udev"
    "LIBPSM2_COMPAT_CONF_DIR=/etc"
  ];

  src = fetchFromGitHub {
    owner = "intel";
    repo = "opa-psm2";
    rev = "PSM2_${version}";
    sha256 = "sha256-HsM2OaoX+SdbIednX1MWw1M4kkkPwUs5Dm32q2H7Mg4=";
  };

  postInstall = ''
    mv $out/usr/* $out
    rmdir $out/usr
  '';

  meta = with lib; {
    homepage = "https://github.com/intel/opa-psm2";
    description = "The PSM2 library supports a number of fabric media and stacks";
    license = with licenses; [ gpl2 bsd3 ];
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.bzizou ];
  };
}
