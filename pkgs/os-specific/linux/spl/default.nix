{ fetchFromGitHub, stdenv, autoreconfHook, coreutils, gawk

# Kernel dependencies
, kernel
}:

with stdenv.lib;

let
  common = { version
    , sha256
    , rev ? "spl-${version}"
    , broken ? false
    } @ args : stdenv.mkDerivation rec {
      name = "spl-${version}-${kernel.version}";

      src = fetchFromGitHub {
        owner = "zfsonlinux";
        repo = "spl";
        inherit rev sha256;
      };

      patches = [ ./const.patch ./install_prefix.patch ];

      nativeBuildInputs = [ autoreconfHook ] ++ kernel.moduleBuildDependencies;

      hardeningDisable = [ "pic" ];

      preConfigure = ''
        substituteInPlace ./module/spl/spl-generic.c --replace /usr/bin/hostid hostid
        substituteInPlace ./module/spl/spl-generic.c --replace "PATH=/sbin:/usr/sbin:/bin:/usr/bin" "PATH=${coreutils}:${gawk}:/bin"
        substituteInPlace ./module/splat/splat-vnode.c --replace "PATH=/sbin:/usr/sbin:/bin:/usr/bin" "PATH=${coreutils}:/bin"
        substituteInPlace ./module/splat/splat-linux.c --replace "PATH=/sbin:/usr/sbin:/bin:/usr/bin" "PATH=${coreutils}:/bin"
      '';

      configureFlags = [
        "--with-config=kernel"
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

        inherit broken;

        homepage = http://zfsonlinux.org/;
        platforms = platforms.linux;
        license = licenses.gpl2Plus;
        maintainers = with maintainers; [ jcumming wizeman wkennington fpletz globin ];
      };
  };
in
  assert kernel != null;
{
    splStable = common {
      version = "0.7.6";
      sha256 = "1l641d89k48ngmarx9mxh8gw2zzrf7fw7n8zmslhz4h1152plddb";
    };

    splUnstable = common {
      version = "2018-01-24";
      rev = "23602fdb39e1254c669707ec9d2d0e6bcdbf1771";
      sha256 = "09py2dwj77f6s2qcnkwdslg5nxb3hq2bq39zpxpm6msqyifhl69h";
    };

    splLegacyCrypto = common {
      version = "2018-01-24";
      rev = "23602fdb39e1254c669707ec9d2d0e6bcdbf1771";
      sha256 = "09py2dwj77f6s2qcnkwdslg5nxb3hq2bq39zpxpm6msqyifhl69h";
    };
}
