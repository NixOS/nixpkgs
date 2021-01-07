{ stdenv
, cmake
, fetchFromGitHub
, libjpeg
, libmcrypt
, libmhash
, libtool
, zlib
}:

stdenv.mkDerivation rec {
  pname = "stegseek";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "RickdeJager";
    repo = pname;
    rev = "v${version}";
    sha256 = "19hzr5533b607ihmjj71x682qjr45s75cqxh9zap21z16346ahqn";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    libjpeg
    libmcrypt
    libmhash
    libtool
    zlib
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Tool to crack steganography";
    longDescription = ''
      Stegseek is a lightning fast steghide cracker that can be
      used to extract hidden data from files.
    '';
    homepage = "https://github.com/RickdeJager/stegseek";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ fab ];
  };
}
