{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:
buildFishPlugin {
  pname = "transient-fish";
  version = "0-unstable-2024-03-10";

  src = fetchFromGitHub {
    owner = "zzhaolei";
    repo = "transient.fish";
    rev = "be0093f1799462a93953e69896496dee4d063fd6";
    hash = "sha256-rEkCimnkxcydKRI2y4DxEM7FD7F2/cGTZJN2Edq/Acc=";
  };

  meta = with lib; {
    description = "Fish plugin to enable a transient prompt";
    homepage = "https://github.com/zzhaolei/transient.fish";
    license = licenses.mit;
    maintainers = with maintainers; [ iynaix ];
  };
}
