{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "unifdef-${version}";
  version = "2.11";

  src = fetchFromGitHub {
    owner = "fanf2";
    repo = "unifdef";
    rev = "8697cc11a1bb67c1153ecc556b880d1fdc4b4e00";
    sha256 = "0d842m4zqbl5h8qiga1bp3vdirs01wd878rz0dkf32illkimmg0y";
  };

  makeFlags = [
    "prefix=$(out)"
    "DESTDIR="
  ];

  preBuild = ''
  echo 'V="${name}"' > version.sh
  '';

  meta = with stdenv.lib; {
    homepage = "http://dotat.at/prog/unifdef/";
    description = "Selectively remove C preprocessor conditionals";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = [ maintainers.vrthra ];
  };
}
