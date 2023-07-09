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
  version = "4.3.13";

  src = fetchFromGitHub {
    owner = "cminyard";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-SAyZ1Ob6swF6i1LFLpwyfMVSi/tOAfz6aiUNOVeJIa0=";
  };

  passthru = {
    updateScript = nix-update-script { };
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];

  buildInputs = [ gensio libyaml ];

  meta = with lib; {
    description = "Serial to network connection server";
    homepage = "https://github.com/cminyard/ser2net";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ emantor ];
    platforms = with platforms; linux;
  };
}
