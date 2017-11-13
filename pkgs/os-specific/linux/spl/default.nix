{ fetchFromGitHub, stdenv, autoreconfHook, coreutils, gawk
, configFile ? "all"

# Kernel dependencies
, kernel ? null
}:

with stdenv.lib;

let
  buildKernel = any (n: n == configFile) [ "kernel" "all" ];
  buildUser = any (n: n == configFile) [ "user" "all" ];
  common = { version
    , sha256
    , rev ? "spl-${version}"
    } @ args : stdenv.mkDerivation rec {
      name = "spl-${configFile}-${version}${optionalString buildKernel "-${kernel.version}"}";

      src = fetchFromGitHub {
        owner = "zfsonlinux";
        repo = "spl";
        inherit rev sha256;
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

        broken = kernel != null && stdenv.lib.versionAtLeast kernel.version "4.14";

        homepage = http://zfsonlinux.org/;
        platforms = platforms.linux;
        license = licenses.gpl2Plus;
        maintainers = with maintainers; [ jcumming wizeman wkennington fpletz globin ];
      };
  };
in
  assert any (n: n == configFile) [ "kernel" "user" "all" ];
  assert buildKernel -> kernel != null;
{
    splStable = common {
      version = "0.7.3";
      sha256 = "0j8mb9ky3pjz9hnz5w6fajpzajl15jq3p0xvxb6lhpqj3rjzsqxb";
    };

    splUnstable = common {
      version = "2017-10-31";
      rev = "35a44fcb8d6e346f51be82dfe57562c2ea0c6a9c";
      sha256 = "193clx7b4p4qhgivmhc88dva0186rnhyv58fx0fwnb5zbx70dam1";
    };
}
