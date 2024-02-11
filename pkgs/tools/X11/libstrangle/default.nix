{ lib, stdenv, fetchFromGitLab, fetchpatch, libGL, libX11 }:

stdenv.mkDerivation rec {
  pname = "libstrangle";
  version = "unstable-202202022";

  buildInputs = [ libGL libX11 ];

  src = fetchFromGitLab {
    owner = "torkel104";
    repo = pname;
    rev = "0273e318e3b0cc759155db8729ad74266b74cb9b";
    sha256 = "sha256-h10QA7m7hIQHq1g/vCYuZsFR2NVbtWBB46V6OWP5wgM=";
  };

  makeFlags = [ "prefix=" "DESTDIR=$(out)" ];

  patches = [
    ./nixos.patch
    # Pull the fix pending upstream inclusion for gcc-13:
    #   https://gitlab.com/torkel104/libstrangle/-/merge_requests/29
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://gitlab.com/torkel104/libstrangle/-/commit/4e17025071de1d99630febe7270b4f63056d0dfa.patch";
      hash = "sha256-AKMHAZhCPcn62pi4fBGhw2r8SNSkCDMUCpR3IlmJ7wQ=";
    })
  ];

  postPatch = ''
    substituteAllInPlace src/strangle.sh
    substituteAllInPlace src/stranglevk.sh
  '';
  postInstall = ''
    substitute $out/share/vulkan/implicit_layer.d/libstrangle_vk.json $out/share/vulkan/implicit_layer.d/libstrangle_vk.x86.json \
      --replace "libstrangle_vk.so" "$out/lib/libstrangle/lib32/libstrangle_vk.so"
    substituteInPlace $out/share/vulkan/implicit_layer.d/libstrangle_vk.json \
      --replace "libstrangle_vk.so" "$out/lib/libstrangle/lib64/libstrangle_vk.so"
  '';

  meta = with lib; {
    homepage = "https://gitlab.com/torkel104/libstrangle";
    description = "Frame rate limiter for Linux/OpenGL";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ aske ];
    mainProgram = "strangle";
  };
}
