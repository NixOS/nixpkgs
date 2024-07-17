{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  help2man,
}:

stdenv.mkDerivation rec {
  pname = "postsrsd";
  version = "1.12";

  src = fetchFromGitHub {
    owner = "roehling";
    repo = "postsrsd";
    rev = version;
    sha256 = "sha256-aSI9TR1wSyMA0SKkbavk+IugRfW4ZEgpzrNiXn0F5ak=";
  };

  cmakeFlags = [
    "-DGENERATE_SRS_SECRET=OFF"
    "-DINIT_FLAVOR=systemd"
  ];

  preConfigure = ''
    sed -i "s,\"/etc\",\"$out/etc\",g" CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    help2man
  ];

  meta = with lib; {
    homepage = "https://github.com/roehling/postsrsd";
    description = "Postfix Sender Rewriting Scheme daemon";
    mainProgram = "postsrsd";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ abbradar ];
  };
}
