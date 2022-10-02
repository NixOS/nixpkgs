{ lib, stdenv, fetchFromGitHub, libbsd, pkg-config }:

stdenv.mkDerivation rec {
  pname = "signify";
  version = "31";

  src = fetchFromGitHub {
    owner = "aperezdc";
    repo = "signify";
    rev = "v${version}";
    sha256 = "sha256-y9jWG1JJhYCn6e5E2qjVqK8nmZpktiB7d9e9uP+3DLo=";
  };

  doCheck = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libbsd ];

  postPatch = ''
    substituteInPlace Makefile --replace "shell pkg-config" "shell $PKG_CONFIG"
  '';

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "OpenBSD signing tool";
    longDescription = ''
      OpenBSDs signing tool, which uses the Ed25519 public key signature system
      for fast signing and verification of messages using small public keys.
    '';
    homepage = "https://www.tedunangst.com/flak/post/signify";
    license = licenses.isc;
    maintainers = [ maintainers.rlupton20 ];
    platforms = platforms.linux;
  };
}
