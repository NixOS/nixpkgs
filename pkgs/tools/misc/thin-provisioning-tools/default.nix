{ stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, expat, libaio, boost }:

stdenv.mkDerivation rec {
  name = "thin-provisioning-tools-${version}";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "jthornber";
    repo = "thin-provisioning-tools";
    rev = "v${version}";
    sha256 = "175mk3krfdmn43cjw378s32hs62gq8fmq549rjmyc651sz6jnj0g";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ expat libaio boost ];

  patches = [
    (fetchpatch {
      # a) Fix build if limits.h provides definition for PAGE_SIZE, as musl does w/musl per XSI[1] although it's apparently optional [2].
      #    This value is only provided when it's known to be a constant, to avoid the need to discover the value dynamically.
      # b) If not using system-provided (kernel headers, or libc headers, or something) use the POSIX approach of querying the value
      #    dynamically using sysconf(_SC_PAGE_SIZE) instead of hardcoded value that hopefully is correct.
      # [1] http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/limits.h.html
      # [2] http://www.openwall.com/lists/musl/2015/09/11/8
      url = "https://raw.githubusercontent.com/void-linux/void-packages/a0ece13ad7ab2aae760e09e41e0459bd999a3695/srcpkgs/thin-provisioning-tools/patches/musl.patch";
      sha256 = "1m8r3vhrnsy8drgs0svs3fgpi3mmxzdcqsv6bmvc0j52cvfqvhvy";
      extraPrefix = ""; # empty means add 'a/' and 'b/'
    })
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://github.com/jthornber/thin-provisioning-tools/;
    description = "A suite of tools for manipulating the metadata of the dm-thin device-mapper target";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ globin ];
  };
}
