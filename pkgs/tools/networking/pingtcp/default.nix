{ stdenv, fetchgit, cmake }:

stdenv.mkDerivation rec {
  name = "pingtcp-${version}";
  version = "0.0.3";

  # This project uses git submodules, which fetchFromGitHub doesn't support:
  src = fetchgit {
    sha256 = "0an4dbwcp2qv1n068q0s34lz88vl1z2rqfh3j9apbq7bislsrwdd";
    rev = "refs/tags/v${version}";
    url = "https://github.com/LanetNetwork/pingtcp.git";
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
