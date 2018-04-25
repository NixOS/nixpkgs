{ stdenv, fetchFromGitHub, makeWrapper, libpcap }:

stdenv.mkDerivation rec {
  name = "masscan-${version}";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner  = "robertdavidgraham";
    repo   = "masscan";
    rev    = "39061a5e9ef158dde1e6618f6fbf379739934a73";
    sha256 = "0mjvwh4i0ncsa3ywavw2s55v5bfv7pyga028c8m8xfash9764wwf";
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
    cp -t $out/share/doc/masscan doc/algorithm.js doc/howto-afl.md doc/bot.hml
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
