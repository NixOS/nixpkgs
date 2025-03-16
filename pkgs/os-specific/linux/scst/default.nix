{ lib, stdenv, bash, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  version = "3.8";
  name = "scst-${version}-${kernel.version}";

  src = fetchFromGitHub {
    owner = "SCST-project";
    repo = "scst";
    rev = "v${version}";
    hash = "sha256-pXpnf8oBwELPGB8aZtgD5X9nV8IZB+cQHZvAfoB71yA=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  hardeningDisable = [ "pic" ];

  outputs = [ "out" "bin" ];

  postPatch = ''
    shopt -s globstar
    substituteInPlace \
      **/Makefile \
      scripts/list-source-files \
      scripts/sign-modules \
      --replace-quiet "/bin/bash" "${lib.getExe bash}"
  '';

  buildPhase = ''
    runHook preBuild

    export KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build
    export BUILD_2X_MODULE=y CONFIG_SCSI_QLA_FC=y CONFIG_SCSI_QLA2XXX_TARGET=y

    make 2release
    for d in scst fcst iscsi-scst qla2x00t-32gbit/qla2x00-target scst_local srpt; do
      make -C $d
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    for d in scst fcst iscsi-scst qla2x00t-32gbit/qla2x00-target scst_local srpt; do
      make PREFIX="" DESTDIR=$bin INSTALL_MOD_PATH=$out -C $d install
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "SCST SCSI target subsystem and QLogic Fibre Channel HBA kernel modules";
    homepage = "https://scst.sourceforge.net";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ titanous ];
    platforms = platforms.linux;
    outputsToInstall = [ "out" "bin" ];
  };
}
