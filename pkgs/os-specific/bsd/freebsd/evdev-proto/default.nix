{ lib, stdenv, makeLinuxHeaders, fetchurl, freebsd, runCommandCC, buildPackages }:
let
  WRKSRC = "include/uapi/linux";
in
stdenv.mkDerivation rec {
  pname = "evdev-proto";
  version = "5.8";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v${lib.versions.major version}.x/linux-${version}.tar.xz";
    hash = "sha256-5/dRhqoGQhFK+PGdmVWZNzAMonrK90UbNtT5sPhc8fU=";
  };
  allFiles = [ "input.h" "input-event-codes.h" "joystick.h" "uinput.h" ];

  nativeBuildInputs = [ buildPackages.freebsd.sed ];

  patchPhase = ''
    sed -i "" -E \
      -e 's/__u([[:digit:]]+)/uint\1_t/g' \
      -e 's/__s([[:digit:]]+)/int\1_t/g' \
      -e '/# *include/ s|<sys/ioctl.h>|<sys/ioccom.h>|' \
      -e '/# *include[[:space:]]+<linux\/types.h>/d' \
      -e '/EVIOC(RMFF|GRAB|REVOKE)/ s/_IOW(.*), *int/_IOWINT\1/' \
      -e '/EVIOCGKEYCODE/ s/_IOR/_IOWR/' \
      -e '/EVIOCGMASK/ s/_IOR/_IOW/' \
      -e '/EVIOCGMTSLOTS/ s/_IOC_READ/IOC_INOUT/' \
      -e '/#define/ s/_IOC_READ/IOC_OUT/' \
      -e '/#define/ s/_IOC_WRITE/IOC_IN/' \
      -e 's/[[:space:]]+__user[[:space:]]+/ /' \
      -e '/__USE_TIME_BITS64/ s|^#if (.*)$|#if 1 /* \1 */|' \
      ${WRKSRC}/input.h
    sed -i "" -E \
      -e 's/__u([[:digit:]]+)/uint\1_t/g' \
      -e 's/__s([[:digit:]]+)/int\1_t/g' \
      -e '/# *include/s|<linux/types.h>|<sys/types.h>|' \
      -e '/#define/ s/_IOW(.*), *int/_IOWINT\1/' \
      -e '/#define/ s/_IOW(.*), *char\*/_IO\1/' \
      -e '/#define/ s/_IOC_READ/IOC_OUT/' \
      ${WRKSRC}/joystick.h \
      ${WRKSRC}/uinput.h
  '';

  buildPhase = ":";

  installPhase = ''
    mkdir -p $out/include/linux
    for f in $allFiles; do
      cp ${WRKSRC}/$f $out/include/linux/$f
    done
  '';

  meta = with lib; {
    description = "Input event device header files for FreeBSD";
    maintainers = with maintainers; [ qyliss rhelmot ];
    platforms = platforms.freebsd;
    license = licenses.gpl2Only;
  };
}
