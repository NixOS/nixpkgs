{ stdenv, kernel, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "anbox-modules";
  version = "2019-11-15-" + kernel.version;

  src = fetchFromGitHub {
    owner = "anbox";
    repo = "anbox-modules";
    rev = "e0a237e571989987806b32881044c539db25e3e1";
    sha256 = "1km1nslp4f5znwskh4bb1b61r1inw1dlbwiyyq3rrh0f0agf8d0v";
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
    homepage = "https://github.com/anbox/anbox-modules";
    license = licenses.gpl2;
    platforms = platforms.linux;
    broken = (versionOlder kernel.version "4.4") || (kernel.features.grsecurity or false) || versionAtLeast kernel.version "5.8";
    maintainers = with maintainers; [ edwtjo ];
  };

}
