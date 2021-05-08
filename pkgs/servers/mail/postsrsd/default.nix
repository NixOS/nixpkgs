{ lib, stdenv, fetchFromGitHub, cmake, help2man }:

stdenv.mkDerivation rec {
  pname = "postsrsd";
  version = "1.10";

  src = fetchFromGitHub {
    owner = "roehling";
    repo = "postsrsd";
    rev = version;
    sha256 = "sha256-AqOHHOnGqOnIw5hPPiJjUJFiwngTux7gwn8qig0t7hs=";
  };

  cmakeFlags = [ "-DGENERATE_SRS_SECRET=OFF" "-DINIT_FLAVOR=systemd" ];

  preConfigure = ''
    sed -i "s,\"/etc\",\"$out/etc\",g" CMakeLists.txt
  '';

  nativeBuildInputs = [ cmake help2man ];

  meta = with lib; {
    homepage = "https://github.com/roehling/postsrsd";
    description = "Postfix Sender Rewriting Scheme daemon";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ abbradar ];
  };
}
