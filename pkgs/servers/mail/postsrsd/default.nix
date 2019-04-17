{ stdenv, fetchFromGitHub, cmake, help2man }:

stdenv.mkDerivation rec {
  name = "postsrsd-${version}";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "roehling";
    repo = "postsrsd";
    rev = version;
    sha256 = "170pbjicpfac8qca2vkp6bpbw42xrcm14b3p1dhnp877glrzlih8";
  };

  cmakeFlags = [ "-DGENERATE_SRS_SECRET=OFF" "-DINIT_FLAVOR=systemd" ];

  preConfigure = ''
    sed -i "s,\"/etc\",\"$out/etc\",g" CMakeLists.txt
  '';

  nativeBuildInputs = [ cmake help2man ];

  meta = with stdenv.lib; {
    homepage = https://github.com/roehling/postsrsd;
    description = "Postfix Sender Rewriting Scheme daemon";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
