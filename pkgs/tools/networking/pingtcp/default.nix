{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "pingtcp-${version}";
  version = "0.0.3";

  # This project uses git submodules, which fetchFromGitHub doesn't support:
  src = fetchFromGitHub {
    sha256 = "0cljga6zc3b07ps47v0fwcvxxi7kfyx2glhx13f2cqsjw538mbaa";
    rev = "refs/tags/v${version}";
    owner = "LanetNetwork";
    repo = "pingtcp";
  };

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  doCheck = false;

  postInstall = ''
    install -Dm644 {..,$out/share/doc/pingtcp}/README.md
  '';

  meta = with stdenv.lib; {
    description = "Measure TCP handshake time";
    homepage = https://github.com/LanetNetwork/pingtcp;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
