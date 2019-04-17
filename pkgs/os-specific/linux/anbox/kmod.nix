{ stdenv, lib, kernel, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "anbox-modules";
  version = "2018-09-08-" + kernel.version;

  src = fetchFromGitHub {
    owner = "anbox";
    repo = "anbox-modules";
    rev = "27fd47e11ef6eef93738f8f3df3e42c88975544e";
    sha256 = "1hnf5x5swjcws6mnxmd3byll8l7qsxxj9pgki2k31rbmqqf2sb0x";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  KERNEL_SRC="${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  buildPhase = ''
    for d in ashmem binder;do
      cd $d
      make
      cd -
    done
  '';

  installPhase = ''
    modDir=$out/lib/modules/${kernel.modDirVersion}/kernel/updates/
    mkdir -p $modDir
    for d in ashmem binder;do
      mv $d/$d*.ko $modDir/.
    done
  '';

  meta = with stdenv.lib; {
    description = "Anbox ashmem and binder drivers.";
    homepage = https://github.com/anbox/anbox-modules;
    license = licenses.gpl2;
    platforms = platforms.linux;
    broken = (versionOlder kernel.version "4.4") || (kernel.features.grsecurity);
    maintainers = with maintainers; [ edwtjo ];
  };

}
