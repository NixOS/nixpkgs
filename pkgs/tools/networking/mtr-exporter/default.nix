<<<<<<< HEAD
{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mtr-exporter";
  version = "0.3.0";
=======
{ lib, buildGoModule, fetchurl, fetchFromGitHub }:

buildGoModule rec {
  pname = "mtr-exporter";
  version = "0.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mgumz";
    repo = "mtr-exporter";
<<<<<<< HEAD
    rev = version;
    hash = "sha256-vVYdIfogXHixf1/7+uGKSxbqVmr9NeCUuNVYE07HoBw=";
  };

  vendorHash = null;
=======
    rev = "3ce854a53a44780d2294f59284d21b06aeae6940";
    sha256 = "sha256-PZCSuvtTBD7yoUE1fR9Z/u3aa1BZgbrcj18smnWRYf4=";
  };

  vendorSha256 = "0njn0ac7j3lv8ax6jc3bg3hh96a42jal212qk6zxrd46nb5l1rj8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = ''
      Mtr-exporter periodically executes mtr to a given host and
      provides the measured results as prometheus metrics.
    '';
    homepage = "https://github.com/mgumz/mtr-exporter";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jakubgs ];
  };
}
