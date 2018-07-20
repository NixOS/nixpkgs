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
    }: stdenv.mkDerivation rec {
      name = "spl-${version}-${kernel.version}";

      src = fetchFromGitHub {
        owner = "zfsonlinux";
        repo = "spl";
        inherit rev sha256;
      };

      inherit patches;

      nativeBuildInputs = [ autoreconfHook ] ++ kernel.moduleBuildDependencies;

      hardeningDisable = [ "fortify" "stackprotector" "pic" ];

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
      version = "0.7.9";
      sha256 = "0540m1dv9jvrzk9kw61glg0h0cwj976mr9zb42y3nh17k47ywff0";
      patches = [ ./install_prefix-0.7.9.patch ];
    };

    splUnstable = common {
      version = "2018-05-07";
      rev = "1149b62d20b7ed9d8ae25d5da7a06213d79b7602";
      sha256 = "07qlx7l23y696gzyy7ynly7n1141w66y21gkmxiia2xwldj8klkx";
      patches = [ ./install_prefix.patch ];
    };

    splLegacyCrypto = common {
      version = "2018-01-24";
      rev = "23602fdb39e1254c669707ec9d2d0e6bcdbf1771";
      sha256 = "09py2dwj77f6s2qcnkwdslg5nxb3hq2bq39zpxpm6msqyifhl69h";
      patches = [ ./install_prefix.patch ];
    };
}
