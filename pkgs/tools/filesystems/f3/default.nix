{ stdenv, fetchFromGitHub
, parted, udev
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "f3";
  version = "7.0";

  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "AltraMayor";
    repo = pname;
    rev = "v${version}";
    sha256 = "195j2zd747ffbsl8p5rf7dyn1j5n05zfqy1s9fm4y6lz8yc1nr17";
  };

  buildInputs = [ parted udev ];

  patchPhase = "sed -i 's/-oroot -groot//' Makefile";

  buildFlags   = [ "all"                    # f3read, f3write
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
