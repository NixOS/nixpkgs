{ stdenv, lib, fetchFromGitHub, kernel }:

let
  modDestDir = "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/realtek/rtw88";
in
stdenv.mkDerivation {
  pname = "rtw88";
  version = "unstable-2022-05-08";

  src = fetchFromGitHub {
    owner = "lwfinger";
    repo = "rtw88";
    rev = "ce979583dff5fc2f6cbce354c3e2dceafee454ca";
    hash = "sha256-/hEytY5kbOgH/fatboOO5yDxVq6kUtGFQeF2UO7OX28=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;
  makeFlags = kernel.makeFlags ++ [ "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    mkdir -p ${modDestDir}
    find . -name '*.ko' -exec cp --parents {} ${modDestDir} \;
    find ${modDestDir} -name '*.ko' -exec xz -f {} \;

    runHook postInstall
  '';

  meta = with lib; {
    description = "The newest Realtek rtlwifi codes";
    homepage = "https://github.com/lwfinger/rtw88";
    license = with licenses; [ bsd3 gpl2Only ];
    maintainers = with maintainers; [ tvorog atila ];
    platforms = platforms.linux;
    broken = kernel.kernelOlder "4.14" || kernel.kernelAtLeast "5.14";
    priority = -1;
  };
}
