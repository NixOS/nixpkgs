{ stdenv, kernel, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "anbox-modules";
  version = "2019-07-13-" + kernel.version;

  src = fetchFromGitHub {
    owner = "anbox";
    repo = "anbox-modules";
    rev = "816dd4d6e702cf77a44cfe208659af6c39e02b57";
    sha256 = "115xrv3fz5bk51hz8cwb61h0xnrsnv217fxmbpw35a6hjrk7gslc";
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
