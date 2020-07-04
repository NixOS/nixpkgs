{ stdenv, fetchFromGitHub, cmake, bison, pkgconfig
, libuecc, libsodium, libcap, json_c, openssl }:

stdenv.mkDerivation rec {
  pname = "fastd";
  version = "19";

  src = fetchFromGitHub {
    owner  = "Neoraider";
    repo = "fastd";
    rev = "v${version}";
    sha256 = "1h3whjvy2n2cyvbkbg4y1z9vlrn790spzbdhj4glwp93xcykhz5i";
  };

  postPatch = ''
    substituteInPlace src/crypto/cipher/CMakeLists.txt \
      --replace 'add_subdirectory(aes128_ctr)' ""
  '';

  nativeBuildInputs = [ pkgconfig bison cmake ];
  buildInputs = [ libuecc libsodium libcap json_c openssl ];

  cmakeFlags = [
    "-DENABLE_OPENSSL=true"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Fast and Secure Tunneling Daemon";
    homepage = "https://projects.universe-factory.net/projects/fastd/wiki";
    license = with licenses; [ bsd2 bsd3 ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz ];
  };
}
