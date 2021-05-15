{ lib
, stdenv
, fetchFromGitHub
, upx
}:

stdenv.mkDerivation rec {
  pname = "hdl-dump";
  version = "20202807";

  # Using AkuHAK's repo because playstation2's repo is outdated
  src = fetchFromGitHub {
    owner = "AKuHAK";
    repo = pname;
    rev = "0c98b235c83c0fca1da93648f05ea5f940a4aee0";
    sha256 = "1s3wflqjjlcslpa9n5chr8dbamhmfk88885dzw68apz4vf6g27iq";
  };

  buildInputs = [ upx ];

  makeFlags = [ "RELEASE=yes" ];

  installPhase = ''
    install -Dm755 hdl_dump -t $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/AKuHAK/hdl-dump";
    description = "PlayStation 2 HDLoader image dump/install utility";
    platforms = platforms.linux;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ makefu ];
  };
}
