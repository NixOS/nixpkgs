{ stdenv, fetchFromGitHub, kernel, perl, kmod, libelf }:
let
  version = "1.62-pre";
in
stdenv.mkDerivation {
  name = "ndiswrapper-${version}-${kernel.version}";
  inherit version;

  hardeningDisable = [ "pic" ];

  patches = [ ./no-sbin.patch ];

  # need at least .config and include
  kernel = kernel.dev;

  buildPhase = "
    cd ndiswrapper
    echo make KBUILD=$(echo \$kernel/lib/modules/*/build);
    echo -n $kernel/lib/modules/*/build > kbuild_path
    export PATH=${kmod}/sbin:$PATH
    make KBUILD=$(echo \$kernel/lib/modules/*/build);
  ";

  installPhase = ''
    make install KBUILD=$(cat kbuild_path) DESTDIR=$out
    mv $out/usr/sbin/* $out/sbin/
    mv $out/usr/share $out/
    rm -r $out/usr

    patchShebangs $out/sbin
  '';

  # should we use unstable?
  src = fetchFromGitHub {
    owner = "pgiri";
    repo = "ndiswrapper";
    rev = "f4d16afb29ab04408d02e38d4ea1148807778e21";
    sha256 = "0iaw0vhchmqf1yh14v4a6whnbg4sx1hag8a4hrsh4fzgw9fx0ij4";
  };

  buildInputs = [ perl libelf ];

  meta = {
    description = "Ndis driver wrapper for the Linux kernel";
    homepage = https://sourceforge.net/projects/ndiswrapper;
    license = "GPL";
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
