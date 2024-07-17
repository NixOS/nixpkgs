{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "kati-unstable";
  version = "2019-09-23";

  src = fetchFromGitHub {
    owner = "google";
    repo = "kati";
    rev = "9da3296746a0cd55b38ebebf91e7f57105a4c36f";
    sha256 = "0s5dfhgpcbx12b1fqmm8p0jpvrhgrnl9qywv1ksbwhw3pfp7j866";
  };

  patches = [ ./version.patch ];

  installPhase = ''
    install -D ckati $out/bin/ckati
  '';

  meta = with lib; {
    description = "An experimental GNU make clone";
    mainProgram = "ckati";
    homepage = "https://github.com/google/kati";
    platforms = platforms.all;
    license = licenses.asl20;
    maintainers = with maintainers; [ danielfullmer ];
  };
}
