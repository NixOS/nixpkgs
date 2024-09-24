{ lib, stdenv, fetchFromGitHub, autoreconfHook, libiconv }:

stdenv.mkDerivation rec {
  pname = "cconv";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "xiaoyjy";
    repo = "cconv";
    rev = "v${version}";
    sha256 = "RAFl/+I+usUfeG/l17F3ltThK7G4+TekyQGwzQIgeH8=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libiconv ];

  meta = with lib; {
    description = "Iconv based simplified-traditional chinese conversion tool";
    mainProgram = "cconv";
    homepage = "https://github.com/xiaoyjy/cconv";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.redfish64 ];
  };
}
