{ fetchFromGitHub, stdenv, autoreconfHook, coreutils, gawk
, configFile ? "all"

# Kernel dependencies
, kernel ? null
}:

with stdenv.lib;
let
  buildKernel = any (n: n == configFile) [ "kernel" "all" ];
  buildUser = any (n: n == configFile) [ "user" "all" ];

  common = { version, sha256 } @ args : stdenv.mkDerivation rec {
    name = "spl-${configFile}-${version}${optionalString buildKernel "-${kernel.version}"}";

    src = fetchFromGitHub {
      owner = "zfsonlinux";
      repo = "spl";
      rev = "spl-${version}";
      inherit sha256;
    };

    patches = [ ./const.patch ./install_prefix.patch ];

    nativeBuildInputs = [ autoreconfHook ];

    hardeningDisable = [ "pic" ];

    preConfigure = ''
      substituteInPlace ./module/spl/spl-generic.c --replace /usr/bin/hostid hostid
      substituteInPlace ./module/spl/spl-generic.c --replace "PATH=/sbin:/usr/sbin:/bin:/usr/bin" "PATH=${coreutils}:${gawk}:/bin"
      substituteInPlace ./module/splat/splat-vnode.c --replace "PATH=/sbin:/usr/sbin:/bin:/usr/bin" "PATH=${coreutils}:/bin"
      substituteInPlace ./module/splat/splat-linux.c --replace "PATH=/sbin:/usr/sbin:/bin:/usr/bin" "PATH=${coreutils}:/bin"
    '';

    configureFlags = [
      "--with-config=${configFile}"
    ] ++ optionals buildKernel [
      "--with-linux=${kernel.dev}/lib/modules/${kernel.modDirVersion}/source"
      "--with-linux-obj=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    ];

    enableParallelBuilding = true;

    meta = {
      description = "Kernel module driver for solaris porting layer (needed by in-kernel zfs)";

      longDescription = ''
          This kernel module is a porting layer for ZFS to work inside the linux
          kernel.
      '';

      homepage = http://zfsonlinux.org/;
      platforms = platforms.linux;
      license = licenses.gpl2Plus;
      maintainers = with maintainers; [ jcumming wizeman wkennington fpletz ];
    };
  };

in
  assert any (n: n == configFile) [ "kernel" "user" "all" ];
  assert buildKernel -> kernel != null;
  {
    splStable = common {
      version = "0.6.5.9";
      sha256 = "15qpx2nhprmk14jgb7yqp9dvfb6i3hhhspi77kvian171b0a6112";
    };
    splUnstable = common {
      version = "0.7.0-rc3";
      sha256 = "09v5gh7mqdl3bfq5an9iiw9fw3l1skprclxdz7r19bw3ids3lfja";
    };
  }
