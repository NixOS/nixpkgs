{ stdenv, fetchFromGitHub, libbsd, pkgconfig }:

stdenv.mkDerivation rec {
  name = "signify-${version}";
  version = "25";

  src = fetchFromGitHub {
    owner = "aperezdc";
    repo = "signify";
    rev = "v${version}";
    sha256 = "0zg0rffxwj2a71s1bllhrn491xsmirg9sshpq8f3vl25lv4c2cnq";
  };

  doCheck = true;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libbsd ];

  preInstall = ''
    export PREFIX=$out
  '';

  meta = with stdenv.lib; {
    description = "OpenBSD signing tool";
    longDescription = ''
      OpenBSDs signing tool, which uses the Ed25519 public key signature system
      for fast signing and verification of messages using small public keys.
    '';
    homepage = https://www.tedunangst.com/flak/post/signify;
    license = licenses.isc;
    maintainers = [ maintainers.rlupton20 ];
    platforms = platforms.linux;
  };
}
