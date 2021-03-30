{ lib, stdenv, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  pname = "nullfs";
  version = "0.3-git";
  # why rename from nullfsvfs to nullfs?
  # * shorter
  # * the module name is nullfs
  # * this is an improved version of https://github.com/xrgtn/nullfs
  name = "${pname}-${version}+linux-${kernel.version}";
  moduleName = "nullfs";
  src = fetchFromGitHub {
    owner = "abbbi";
    repo = "nullfsvfs";
    rev = "802930fb0e66c3e0ba7c81f2c87caa1dcd874b3f";
    sha256 = "13qqc29jaa9s8hb7bvkrv4vfzy9cfmjdpmd4rysppi8x6cdlzhva";
  };

  hardeningDisable = [ "pic" "format" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  preBuild = ''
    # workaround for 'permission denied' with M="$src"
    mkdir "$out"
    cp -r "$src" "$out/build"
    chmod +w "$out/build"
  '';
  buildPhase = ''
    make -C "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" M="$out/build" modules
  '';
  installPhase = ''
    # install to userspace
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/extra
    xz $out/build/${moduleName}.ko
    mv $out/build/${moduleName}.ko.xz $out/lib/modules/${kernel.modDirVersion}/extra/
    # remove temp files
    chmod -R +w $out/build
    rm -r $out/build
  '';
  meta = with lib; {
    description = "Virtual black hole file system that behaves like /dev/null";
    longDescription = ''
      usage:
      modprobe nullfs
      mkdir /tmp/nullfs
      mount -t nullfs nullfs /tmp/nullfs
    '';
    homepage = "https://github.com/abbbi/nullfsvfs";
    license = licenses.gpl1;
    platforms = platforms.linux;
  };
}
