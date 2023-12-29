nvidia_x11: sha256:

{ stdenv, lib, fetchurl, patchelf }:

let
  sys = with lib; concatStringsSep "-" (reverseList (splitString "-" stdenv.system));
  bsys = builtins.replaceStrings ["_"] ["-"] sys;
  fmver = nvidia_x11.version;
in

stdenv.mkDerivation rec {
  pname = "fabricmanager";
  version = fmver;
  src = fetchurl {
    url = "https://developer.download.nvidia.com/compute/nvidia-driver/redist/fabricmanager/" +
          "${sys}/${pname}-${sys}-${fmver}-archive.tar.xz";
    inherit sha256;
  };
  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    find .
    mkdir -p $out/{bin,share/nvidia-fabricmanager}
    for bin in nv{-fabricmanager,switch-audit};do
    ${patchelf}/bin/patchelf \
      --set-interpreter ${stdenv.cc.libc}/lib/ld-${bsys}.so.2 \
      --set-rpath ${lib.makeLibraryPath [ stdenv.cc.libc ]} \
      bin/$bin
    done
    mv bin/nv{-fabricmanager,switch-audit} $out/bin/.
    for d in etc systemd share/nvidia;do
      mv $d $out/share/nvidia-fabricmanager/.
    done
    for d in include lib;do
      mv $d $out/.
    done
  '';

  meta = with lib; {
    homepage = "https://www.nvidia.com/object/unix.html";
    description = "Fabricmanager daemon for NVLink intialization and control";
    license = licenses.unfreeRedistributable;
    platforms = nvidia_x11.meta.platforms;
    mainProgram = "nv-fabricmanager";
    maintainers = with maintainers; [ edwtjo ];
  };
}
