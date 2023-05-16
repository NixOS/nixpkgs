{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "up";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "akavel";
    repo = "up";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-d6FCJ9G9ytHhWQ5lXEtlmzclt3odS9e+Y1ry6EiIDsk=";
  };

  vendorHash = "sha256-PbOMUrKigCUuu5Hv3h0ZYSYezS+64DIZSubnQZ12HOE=";
=======
    sha256 = "1j8fi14fiwjscfzdfjqxgavjadwvcm5mqr8fb7hx3jmxs4kl58bp";
  };

  vendorSha256 = "1q8wfsfl3rz698ck5q5s5z6iw9k134fxxvwipcp2b052n998rcrx";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Ultimate Plumber is a tool for writing Linux pipes with instant live preview";
    homepage = "https://github.com/akavel/up";
    maintainers = with maintainers; [ ma27 ];
    license = licenses.asl20;
  };
}
