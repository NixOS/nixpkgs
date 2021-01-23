{ autoreconfHook
, fetchFromGitHub
, gensio
, lib
, libyaml
, nix-update-script
, pkg-config
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "ser2net";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "cminyard";
    repo = pname;
    rev = "v${version}";
    sha256 = "13zhds3zav03f1snc4bb1j07i2x606bmnqm17yx37frib2hjs4nx";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];

  buildInputs = [ gensio libyaml ];

  meta = with lib; {
    description = "Serial to network connection server";
    homepage = "https://sourceforge.net/projects/ser2net/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ emantor ];
    platforms = with platforms; linux;
  };
}
