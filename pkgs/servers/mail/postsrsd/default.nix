{ stdenv, fetchFromGitHub, cmake, help2man }:

stdenv.mkDerivation rec {
  name = "postsrsd-${version}";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "roehling";
    repo = "postsrsd";
    rev = version;
    sha256 = "09yzb0fvnbfy534maqlqk79c41p1yz8r9f73n7bahm5lwd0livk9";
  };

  cmakeFlags = [ "-DGENERATE_SRS_SECRET=OFF" "-DINIT_FLAVOR=systemd" ];

  preConfigure = ''
    sed -i "s,\"/etc\",\"$out/etc\",g" CMakeLists.txt
  '';

  nativeBuildInputs = [ cmake help2man ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/roehling/postsrsd";
    description = "Postfix Sender Rewriting Scheme daemon";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
