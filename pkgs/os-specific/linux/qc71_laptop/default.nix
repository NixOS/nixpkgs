{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
}:

stdenv.mkDerivation rec {
  pname = "qc71_laptop";
  version = "0-unstable-2025-01-07";

  src = fetchFromGitHub {
    owner = "pobrn";
    repo = "qc71_laptop";
    rev = "ebab4af0b2c5b162bb9f27c80cd284c36b8fb7a9";
    hash = "sha256-sRvxcdocYKnwMH/qYkKj66uClI1bSmMSxXHrHsc7uco=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "VERSION=${version}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    runHook preInstall
    install -D qc71_laptop.ko -t $out/lib/modules/${kernel.modDirVersion}/extra
    runHook postInstall
  '';

  meta = with lib; {
    description = "Linux driver for QC71 laptop";
    homepage = "https://github.com/pobrn/qc71_laptop/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ aacebedo ];
    platforms = platforms.linux;
  };
}
