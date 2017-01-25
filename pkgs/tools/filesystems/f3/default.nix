{ stdenv, fetchFromGitHub
, parted, udev
}:
let
  version = "6.0-2016.11.16-unstable";
in
stdenv.mkDerivation rec {
  name = "f3-${version}";

  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "AltraMayor";
    repo = "f3";
    rev = "eabf001f69a788e64912bc9e812c118a324077d5";
    sha256 = "0ypqyqwqiy3ynssdd9gamk1jxywg6avb45ndlzhv3wxh2qcframm";
  };

  buildInputs = [ parted udev ];

  patchPhase = "sed -i 's/-oroot -groot//' Makefile";

  buildFlags   = [ "CFLAGS=-fgnu89-inline"  # HACK for weird gcc incompatibility with -O2
                   "all"                    # f3read, f3write
                   "extra"                  # f3brew, f3fix, f3probe
                 ];

  installFlags = [ "PREFIX=$(out)"
                   "install"
                   "install-extra"
                 ];

  meta = {
    description = "Fight Flash Fraud";
    homepage = http://oss.digirati.com.br/f3/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ makefu ];
  };
}
