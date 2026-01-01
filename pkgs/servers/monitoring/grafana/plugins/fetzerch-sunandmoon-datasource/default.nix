{ grafanaPlugin, lib }:

grafanaPlugin {
  pname = "fetzerch-sunandmoon-datasource";
  version = "0.3.3";
  zipHash = "sha256-IJe1OiPt9MxqqPymuH0K27jToSb92M0P4XGZXvk0paE=";
<<<<<<< HEAD
  meta = {
    description = "Calculates the position of Sun and Moon as well as the Moon illumination using SunCalc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nagisa ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Calculates the position of Sun and Moon as well as the Moon illumination using SunCalc";
    license = licenses.mit;
    maintainers = with maintainers; [ nagisa ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
