{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "up";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "akavel";
    repo = "up";
    rev = "v${version}";
    sha256 = "1j8fi14fiwjscfzdfjqxgavjadwvcm5mqr8fb7hx3jmxs4kl58bp";
  };

  vendorSha256 = "1q8wfsfl3rz698ck5q5s5z6iw9k134fxxvwipcp2b052n998rcrx";

  meta = with lib; {
    description = "Ultimate Plumber is a tool for writing Linux pipes with instant live preview";
    homepage = "https://github.com/akavel/up";
    maintainers = with maintainers; [ ma27 ];
    license = licenses.asl20;
  };
}
