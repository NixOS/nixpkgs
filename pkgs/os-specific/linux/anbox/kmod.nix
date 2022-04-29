{ lib, stdenv, kernel, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "anbox-modules";
  version = "2020-06-14-${kernel.version}";

  src = fetchFromGitHub {
    owner = "anbox";
    repo = "anbox-modules";
    rev = "98f0f3b3b1eeb5a6954ca15ec43e150b76369086";
    sha256 = "sha256-6xDJQ4YItdbYqle/9VNfOc7D80yFGd9cFyF+CuABaF0=";
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

  meta = with lib; {
    description = "Anbox ashmem and binder drivers.";
    homepage = "https://github.com/anbox/anbox-modules";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    broken = kernel.kernelAtLeast "5.5";
    maintainers = with maintainers; [ edwtjo ];
  };
}
