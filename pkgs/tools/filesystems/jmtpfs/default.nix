{ stdenv, fetchFromGitHub, pkgconfig, file, fuse, libmtp }:

let version = "0.5"; in
stdenv.mkDerivation {
  pname = "jmtpfs";
  inherit version;

  src = fetchFromGitHub {
    sha256 = "1pm68agkhrwgrplrfrnbwdcvx5lrivdmqw8pb5gdmm3xppnryji1";
    rev = "v${version}";
    repo = "jmtpfs";
    owner = "JasonFerrara";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ file fuse libmtp ];

  meta = with stdenv.lib; {
    description = "A FUSE filesystem for MTP devices like Android phones";
    homepage = https://github.com/JasonFerrara/jmtpfs;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ maintainers.coconnor ];
  };
}
