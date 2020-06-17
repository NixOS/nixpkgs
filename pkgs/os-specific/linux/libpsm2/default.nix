{ stdenv, fetchFromGitHub, numactl, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "libpsm2";
  version = "11.2.156";
  ifs_version = "10_10_2_0_44";

  preConfigure= ''
    export UDEVDIR=$out/etc/udev
    substituteInPlace ./Makefile --replace "udevrulesdir}" "prefix}/etc/udev";
  '';

  enableParallelBuilding = true;

  buildInputs = [ numactl pkgconfig ];

  installFlags = [ 
    "DESTDIR=$(out)"
    "UDEVDIR=/etc/udev"
    "LIBPSM2_COMPAT_CONF_DIR=/etc"
  ];

  src = fetchFromGitHub {
    owner = "intel";
    repo = "opa-psm2";
    rev = "IFS_RELEASE_${ifs_version}";
    sha256 = "0ckrfzih1ga9yvximxjdh0z05kn9l858ykqiblv18w6ka3gra1xz";
  };

  postInstall = ''
    mv $out/usr/* $out
    rmdir $out/usr
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/intel/opa-psm2";
    description = "The PSM2 library supports a number of fabric media and stacks";
    license = with licenses; [ gpl2 bsd3 ];
   platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.bzizou ];
  };
}
