{ lib, stdenv, fetchFromGitHub, makeWrapper, libpcap }:

stdenv.mkDerivation rec {
  pname = "masscan";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "robertdavidgraham";
    repo = "masscan";
    rev = version;
    sha256 = "sha256-gH0zOf2kl6cqws1nB3QPtaAjpvNAgbawXRx77bqJTIc=";
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

  meta = with lib; {
    description = "Fast scan of the Internet";
    homepage = "https://github.com/robertdavidgraham/masscan";
    changelog = "https://github.com/robertdavidgraham/masscan/releases/tag/${version}";
    license = licenses.agpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
