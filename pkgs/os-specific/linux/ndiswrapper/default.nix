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
    rev = "5e29f6a9d41df949b435066c173e3b1947f179d3";
    sha256 = "0sprrmxxkf170bmh1nz9xw00gs89dddr84djlf666bn5bhy6jffi";
  };

  buildInputs = [ perl libelf ];

  meta = {
    description = "Ndis driver wrapper for the Linux kernel";
    homepage = https://sourceforge.net/projects/ndiswrapper;
    license = "GPL";
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
