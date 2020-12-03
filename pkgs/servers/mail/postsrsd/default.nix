{ stdenv, fetchFromGitHub, cmake, help2man }:

stdenv.mkDerivation rec {
  pname = "postsrsd";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "roehling";
    repo = "postsrsd";
    rev = version;
    sha256 = "11yr557m60a62m4wxi20lr8kmagjrgndmnwlxzr241bwb20ba96x";
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
