{ lib, stdenv, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  pname = "hid-ite8291r3";
  version = "unstable-2022-06-01";

  src = fetchFromGitHub {
    owner = "pobrn";
    repo = "hid-ite8291r3";
    rev = "48e04cb96517f8574225ebabb286775feb942ef5";
    hash = "sha256-/69vvVbAVULDW8rwDYSj5706vrqJ6t4s/T6s3vmG9wk=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "VERSION=${version}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    runHook preInstall
    install -D hid-ite8291r3.ko -t $out/lib/modules/${kernel.modDirVersion}/extra
    runHook postInstall
  '';

  meta = with lib; {
    description = "Linux driver for the ITE 8291 RGB keyboard backlight controller";
    homepage = "https://github.com/pobrn/hid-ite8291r3/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ aacebedo ];
    platforms = platforms.linux;
    broken = kernel.kernelOlder "5.9";
  };
}
