{ stdenv, lib, fetchFromGitea, kernel, kmod }:
let
  version = "0.1.1";
in
stdenv.mkDerivation {
  pname = "keymash";
  version = "${version}-${kernel.version}";

  src = fetchFromGitea {
    domain = "git.bsd.gay";
    owner = "fef";
    repo = "keymash";
    rev = "v${version}";
    hash = "sha256-sET3NKH8sS9tIvf68nLiNBVQ1so9bISim0Nxr4kd/0I=";
  };

  hardeningDisable = [ "pic" "format" ];
  nativeBuildInputs = [ kmod ] ++ kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "KERNELRELEASE=${kernel.modDirVersion}"
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];

  meta = with lib; {
    longDescription = ''
      The gay keymash device driver!
      /dev/keymash provides an endless supply of lowercase characters from the QWERTY home row in a cryptographically secure random order.
    '';
    homepage = "https://git.bsd.gay/fef/keymash";
    license = licenses.gpl2;
    maintainers = [ maintainers.aprl ];
    platforms = platforms.linux;
    broken = lib.versionOlder kernel.version "5.10";
  };
}
