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
      version = "0.7.5";
      sha256 = "0njb3274bc5pfr80pzj94sljq457pr71n50s0gsccbz8ghk28rlr";
    };

    splUnstable = common {
      version = "2017-12-21";
      rev = "c9821f1ccc647dfbd506f381b736c664d862d126";
      sha256 = "08r6sa36jaj6n54ap18npm6w85v5yn3x8ljg792h37f49b8kir6c";
    };
}
