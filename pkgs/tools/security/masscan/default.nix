{ stdenv, fetchFromGitHub, makeWrapper, libpcap }:

stdenv.mkDerivation rec {
  name = "masscan-${version}";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner  = "robertdavidgraham";
    repo   = "masscan";
    rev    = "${version}";
    sha256 = "0q0c7bsf0pbl8napry1qyg0gl4pd8wn872h4mz9b56dx4rx90vqg";
  };

  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [ "PREFIX=$(out)" "GITVER=${version}" "CC=cc" ];

  preInstall = ''
    mkdir -p $out/bin
  '';

  postInstall = ''
    mkdir -p $out/share/man/man8
    mkdir -p $out/share/{doc,licenses}/masscan
    mkdir -p $out/etc/masscan

    cp data/exclude.conf $out/etc/masscan
    cp -t $out/share/doc/masscan doc/algorithm.js doc/howto-afl.md doc/bot.html
    cp doc/masscan.8 $out/share/man/man8/masscan.8
    cp LICENSE $out/share/licenses/masscan/LICENSE

    wrapProgram $out/bin/masscan --prefix LD_LIBRARY_PATH : "${libpcap}/lib"
  '';

  meta = with stdenv.lib; {
    description = "Fast scan of the Internet";
    homepage    = https://github.com/robertdavidgraham/masscan;
    license     = licenses.agpl3;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
