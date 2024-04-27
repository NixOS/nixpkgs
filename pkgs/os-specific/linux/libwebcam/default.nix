{ lib
, stdenv
, fetchurl
, cmake
, pkg-config
, libxml2
}:

stdenv.mkDerivation rec {
  pname = "libwebcam";
  version = "0.2.5";

  src = fetchurl {
    url = "mirror://sourceforge/project/${pname}/source/${pname}-src-${version}.tar.gz";
    sha256 = "0hcxv8di83fk41zjh0v592qm7c0v37a3m3n3lxavd643gff1k99w";
  };

  patches = [
    ./uvcdynctrl_symlink_support_and_take_data_dir_from_env.patch
  ];

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ libxml2 ];

  postPatch = ''
    substituteInPlace ./uvcdynctrl/CMakeLists.txt \
      --replace "/lib/udev" "$out/lib/udev"

    substituteInPlace ./uvcdynctrl/udev/scripts/uvcdynctrl \
      --replace 'debug=0' 'debug=''${NIX_UVCDYNCTRL_UDEV_DEBUG:-0}' \
      --replace 'uvcdynctrlpath=uvcdynctrl' "uvcdynctrlpath=$out/bin/uvcdynctrl"

    substituteInPlace ./uvcdynctrl/udev/rules/80-uvcdynctrl.rules \
      --replace "/lib/udev" "$out/lib/udev"
  '';


  preConfigure = ''
    cmakeFlagsArray=(
      $cmakeFlagsArray
      "-DCMAKE_INSTALL_PREFIX=$out"
    )
  '';

  meta = with lib; {
    description = "The webcam-tools package";
    platforms = platforms.linux;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ jraygauthier ];
  };
}
