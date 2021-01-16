{ lib, stdenv, fetchFromGitHub, pkg-config, libdaemon }:

stdenv.mkDerivation rec {
  pname = "btnx";
  version = "2019-07-11";

  src = fetchFromGitHub {
    owner = "cdobrich";
    repo = pname;
    rev = "ef3f5b9aca798213427831a94ed64ed652438470";
    sha256 = "1a6sl6d403bd049ds1i0hbkc0q6lh34a0hk2i3ms1jcyazca284r";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libdaemon ];

  meta = with lib; {
    homepage = "https://github.com/cdobrich/btnx";
    description = "Daemon that sniffs events from the mouse event handler";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ wolfangaukang ];
    platforms = with platforms; linux;
  };
}
