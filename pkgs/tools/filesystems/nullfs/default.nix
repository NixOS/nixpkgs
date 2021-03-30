{ lib, stdenv, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {

  pname = "nullfs";
  version = "0.3";
  name = "${pname}-${version}+linux-${kernel.version}";
  moduleName = pname;

  # why rename from nullfsvfs to nullfs?
  # * shorter
  # * the module name is nullfs
  # * this is an improved version of https://github.com/xrgtn/nullfs

  src = fetchFromGitHub {
    owner = "abbbi";
    repo = "nullfsvfs";
    rev = version;
    sha256 = "01jm22arnff1s58ky76a5061mpwhnz322mp3dva3lyl2vimf3ncw";
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
    runHook preBuild
    # workaround for broken Makefile
    make -j$NIX_BUILD_CORES -C "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" M="$out/build" modules
  '';

  installPhase = ''
    # install to userspace (not initrd)
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
      configuration.nix:
      {
        boot.extraModulePackages = [ pkgs.nullfs ];
      }

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
