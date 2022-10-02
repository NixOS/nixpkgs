{ lib
, stdenv
, fetchFromGitHub
, gettext
, which
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "linux_logo";
  version = "6.0";

  src = fetchFromGitHub {
    owner = "deater";
    repo = pname;
    rev = version;
    sha256 = "sha256-q8QznEgnALJS//l7XXHZlq07pI2jCCm2USEU96rO8N0=";
  };

  nativeBuildInputs = [ gettext which ];

  passthru.updateScript = nix-update-script {
    attrPath = pname;
  };

  meta = with lib; {
    description = "Prints an ASCII logo and some system info";
    homepage = "http://www.deater.net/weave/vmwprod/linux_logo";
    changelog = "https://github.com/deater/linux_logo/blob/${version}/CHANGES_IN_${version}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.linux;
  };
}
