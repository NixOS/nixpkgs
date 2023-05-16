{ lib
, stdenv
, fetchFromGitHub
, glslang
, meson
, ninja
, pkg-config
, libX11
, spirv-headers
, vulkan-headers
, vkbasalt32
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vkbasalt";
<<<<<<< HEAD
  version = "0.3.2.10";
=======
  version = "0.3.2.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "DadSchoorse";
    repo = "vkBasalt";
    rev = "refs/tags/v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-GC6JKYnsfcUBg+CX6v7MyE4FeLmjadFwighaiyureDg=";
=======
    hash = "sha256-IVlZ6o+1EEEh547rFPN7z+W+EY7MrIM/yUh6+PPkNeI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ glslang meson ninja pkg-config ];
  buildInputs = [ libX11 spirv-headers vulkan-headers ];
  mesonFlags = [ "-Dappend_libdir_vkbasalt=true" ];

  postInstall = lib.optionalString (stdenv.hostPlatform.system == "x86_64-linux") ''
    install -Dm 644 $src/config/vkBasalt.conf $out/share/vkBasalt/vkBasalt.conf
    # Include 32bit layer in 64bit build
    ln -s ${vkbasalt32}/share/vulkan/implicit_layer.d/vkBasalt.json \
      "$out/share/vulkan/implicit_layer.d/vkBasalt32.json"
  '';

<<<<<<< HEAD
  # We need to give the different layers separate names or else the loader
  # might try the 32-bit one first, fail and not attempt to load the 64-bit
  # layer under the same name.
  postFixup = ''
    substituteInPlace "$out/share/vulkan/implicit_layer.d/vkBasalt.json" \
      --replace "VK_LAYER_VKBASALT_post_processing" "VK_LAYER_VKBASALT_post_processing_${toString stdenv.hostPlatform.parsed.cpu.bits}"
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A Vulkan post processing layer for Linux";
    homepage = "https://github.com/DadSchoorse/vkBasalt";
    license = licenses.zlib;
    maintainers = with maintainers; [ kira-bruneau ];
    platforms = platforms.linux;
  };
})
