{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "agebox";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "slok";
    repo = pname;
    rev = "v${version}";
    sha256 = "0zn7jibhw5jd9wp1alx9ahj4szaig4a54ci3676kk5zqxr2hjz0c";
  };
  vendorSha256 = "0bc2pwz3yhzwqi0bcwqkkkrglg473qxhmz5s5955fvgajvjk7drn";

  ldflags = [
    "-s" "-w"
    "-X main.Version=${version}"
  ];

  meta = with lib; {
    homepage = "https://github.com/slok/agebox";
    changelog = "https://github.com/slok/agebox/releases/tag/v${version}";
    description = "Age based repository file encryption gitops tool";
    license = licenses.asl20;
    maintainers = with maintainers; [ lesuisse ];
  };
}
