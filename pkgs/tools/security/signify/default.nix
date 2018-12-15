{ stdenv, fetchFromGitHub, libbsd, pkgconfig }:

stdenv.mkDerivation rec {
  name = "signify-${version}";
  version = "24";

  src = fetchFromGitHub {
    owner = "aperezdc";
    repo = "signify";
    rev = "v${version}";
    sha256 = "0grdlrpxcflzmzzc30r8rvsmamvbsgqyni59flzzk4w5hpjh464w";
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
