{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "frogatto-data";
  version = "unstable-2021-05-24";

  src = fetchFromGitHub {
    owner = "frogatto";
    repo = "frogatto";
    # master branch as of 2020-12-17
    rev = "8b0f2bc8f9f172f6225b8e0d806552cb94f35e2a";
    sha256 = "09nrna9l1zj2ma2bazdhdvphwy570kfz4br4xgpwq21rsjrvrqiy";
  };

  installPhase = ''
    mkdir -p $out/share/frogatto/modules
    cp -ar . $out/share/frogatto/modules/frogatto
  '';

  meta = with lib; {
    homepage = "https://github.com/frogatto/frogatto";
    description = "Data files to the frogatto game";
    license = with licenses; [ cc-by-30 unfree ];
    maintainers = with maintainers; [ astro ];
  };
}
