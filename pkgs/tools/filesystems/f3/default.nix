{ stdenv, fetchFromGitHub
, parted, udev
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "f3";
  version = "7.1";

  enableParallelBuilding = true;

  src = fetchFromGitHub {
    owner = "AltraMayor";
    repo = pname;
    rev = "v${version}";
    sha256 = "0zglsmz683jg7f9wc6vmgljyg9w87pbnjw5x4w6x02w8233zvjqf";
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
