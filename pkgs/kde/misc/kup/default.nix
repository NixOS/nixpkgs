{
  lib,
  mkKdeDerivation,
  fetchFromGitLab,
  libgit2,
}:
mkKdeDerivation rec {
  pname = "kup";
  version = "0.10.0";
  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "system";
    repo = "kup";
    rev = "${pname}-${version}";
    hash = "sha256-G/GXmcQI1OBnCE7saPHeHDAMeL2WR6nVttMlKV2e01I=";
  };

  extraBuildInputs = [ libgit2 ];

  meta = with lib; {
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.pwoelfel ];
    teams = [ ];
  };
}
