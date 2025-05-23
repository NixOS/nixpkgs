{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
}:

let
  release = "0.1.0";

in
stdenv.mkDerivation {
  pname = "acer-wmi-battery";
  version = "${kernel.version}-${release}";

  src = fetchFromGitHub {
    owner = "frederik-h";
    repo = "acer-wmi-battery";
    rev = "v" + release;
    hash = "sha256-2uVIMvUxIXWz0nK61ukUg7Rh9SVQbyjWr7++hh8mEC0=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail '/lib/modules/$(shell uname -r)/build' ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build
  '';

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    find . -name '*.ko' -exec xz -f {} \;
    install -Dm444 -t $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/platform/x86 *.ko.xz

    runHook postInstall
  '';

  meta = with lib; {
    description = "Driver for the Acer WMI battery health control interface";
    homepage = "https://github.com/frederik-h/acer-wmi-battery";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
