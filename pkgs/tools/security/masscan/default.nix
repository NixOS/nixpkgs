{ stdenv, fetchFromGitHub, libpcap }:

stdenv.mkDerivation rec {
  name = "masscan-${version}";
  version = "2016-11-03";

  src = fetchFromGitHub {
    owner  = "robertdavidgraham";
    repo   = "masscan";
    rev    = "dc88677a11dc3d9a5f6aa55cc1377bc17dba1496";
    sha256 = "1mdjqkn4gnbwr5nci6i6xn7qzkjgq7dx37fzd6gghv87xgw7cdbg";
  };

  buildInputs = [ libpcap ];

  makeFlags = [ "PREFIX=$(out)" "CC=cc" "-j" ];

  postInstall = ''
    mkdir -p $out/share/man/man8
    mkdir -p $out/share/{doc,licenses}/masscan
    mkdir -p $out/etc/masscan

    cp data/exclude.conf $out/etc/masscan
    cp -t $out/share/doc/masscan doc/algorithm.js doc/howto-afl.md doc/bot.hml
    cp doc/masscan.8 $out/share/man/man8/masscan.8
    cp LICENSE $out/share/licenses/masscan/LICENSE
  '';

  meta = with stdenv.lib; {
    description = "Fast scan of the Internet";
    homepage    = https://github.com/robertdavidgraham/masscan;
    license     = licenses.agpl3;
    platforms   = with platforms; allBut darwin;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
