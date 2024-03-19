{ lib, stdenv, fetchFromGitHub, fetchpatch, ncurses, libpcap }:

stdenv.mkDerivation rec {
  pname = "tcptrack";
  version = "unstable-2017-04-29";

  src = fetchFromGitHub {
    owner = "bchretien";
    repo = "tcptrack";
    rev = "2b096ac103af2884bbd7648cff8adcbadbda9394";
    sha256 = "0084g9s0ynv1az67j08q9nz4p07bqqz9k6w5lprzj3ljlh0x10gj";
  };

  patches = [
    # Fix pending upstream inclusion for ncurses-6.3 support:
    #  https://github.com/bchretien/tcptrack/pull/10
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://github.com/bchretien/tcptrack/commit/409007afbce8ec5a81312a2a4123dd83b62b4494.patch";
      sha256 = "00641jyr52ksww5bbzvxlprmbb36jnvzg2w1aj1jgnm75jiajcfc";
    })
  ];

  buildInputs = [ ncurses libpcap ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=cpp";

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "libpcap based program for live TCP connection monitoring";
    mainProgram = "tcptrack";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor maintainers.vrthra ];
  };
}
