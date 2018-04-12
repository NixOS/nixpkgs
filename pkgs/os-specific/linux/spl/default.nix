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
    , patches ? []
    } @ args : stdenv.mkDerivation rec {
      name = "spl-${version}-${kernel.version}";

      src = fetchFromGitHub {
        owner = "zfsonlinux";
        repo = "spl";
        inherit rev sha256;
      };

      inherit patches;

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
      version = "0.7.8";
      sha256 = "0ypyy7ij280n7rly6ifrvna9k55gxwdx9a7lalf4r1ka714379fi";
      patches = [ ./install_prefix-0.7.8.patch ];
    };

    splUnstable = common {
      version = "2018-04-10";
      rev = "9125f8f5bdb36bfbd2d816d30b6b29b9f89ae3d8";
      sha256 = "00zrbca906rzjd62m4khiw3sdv8x18dapcmvkyaawripwvzc4iri";
      patches = [ ./install_prefix.patch ];
    };

    splLegacyCrypto = common {
      version = "2018-01-24";
      rev = "23602fdb39e1254c669707ec9d2d0e6bcdbf1771";
      sha256 = "09py2dwj77f6s2qcnkwdslg5nxb3hq2bq39zpxpm6msqyifhl69h";
    };
}
