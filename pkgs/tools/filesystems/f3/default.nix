{ stdenv, fetchFromGitHub
, parted, udev
}:

stdenv.mkDerivation rec {
  pname = "f3";
  version = "7.2";

  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "AltraMayor";
    repo = pname;
    rev = "v${version}";
    sha256 = "1iwdg0r4wkgc8rynmw1qcqz62l0ldgc8lrazq33msxnk5a818jgy";
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
