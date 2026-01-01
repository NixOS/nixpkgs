{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nut-exporter";
<<<<<<< HEAD
  version = "3.2.3";
=======
  version = "3.2.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "DRuggeri";
    repo = "nut_exporter";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-tgYxkVen2aegX+py9goQIQtw1eNZJ7K8CqgaKOsDgxA=";
=======
    sha256 = "sha256-p1IUJOSY7dXAzSPBpKvDKvy4etM3q3oI5OXg6l+3KLw=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  vendorHash = "sha256-cMZ4GSal03LIZi7ESr/sQx8zLHNepOTZGEEsdvsNhec=";

  meta = {
    description = "Prometheus exporter for Network UPS Tools";
    mainProgram = "nut_exporter";
    homepage = "https://github.com/DRuggeri/nut_exporter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jhh ];
  };
}
