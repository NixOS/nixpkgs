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

<<<<<<< HEAD
  meta = {
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.pwoelfel ];
=======
  meta = with lib; {
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.pwoelfel ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    teams = [ ];
  };
}
