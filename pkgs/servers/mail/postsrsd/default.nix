{ lib, stdenv, fetchFromGitHub, cmake, help2man }:

stdenv.mkDerivation rec {
  pname = "postsrsd";
  version = "1.11";

  src = fetchFromGitHub {
    owner = "roehling";
    repo = "postsrsd";
    rev = version;
    sha256 = "sha256-M1VtH+AToLh9J4zwIznInfFJzqmKElTvqAgI+qqL+Lw=";
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
