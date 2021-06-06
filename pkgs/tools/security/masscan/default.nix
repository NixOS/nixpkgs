{ lib
, stdenv
, fetchFromGitHub
, installShellFiles
, makeWrapper
, libpcap
}:

stdenv.mkDerivation rec {
  pname = "masscan";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "robertdavidgraham";
    repo = "masscan";
    rev = version;
    sha256 = "sha256-mnGC/moQANloR5ODwRjzJzBa55OEZ9QU+9WpAHxQE/g=";
  };

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  makeFlags = [ "PREFIX=$(out)" "GITVER=${version}" "CC=${stdenv.cc.targetPrefix}cc" ];

  preInstall = ''
    mkdir -p $out/bin
  '';

  postInstall = ''
    installManPage doc/masscan.8

    mkdir -p $out/share/{doc,licenses}/masscan
    mkdir -p $out/etc/masscan

    cp data/exclude.conf $out/etc/masscan
    cp -t $out/share/doc/masscan doc/algorithm.js doc/howto-afl.md doc/bot.html
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
