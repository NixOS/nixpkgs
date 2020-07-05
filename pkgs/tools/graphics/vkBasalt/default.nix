{ stdenv, lib, fetchFromGitHub
, glslang, meson, ninja, pkg-config
, libX11
}:

stdenv.mkDerivation rec {
  pname = "vkBasalt${lib.optionalString stdenv.is32bit "32"}";
  version = "0.3.2.2";

  src = fetchFromGitHub {
    owner = "DadSchoorse";
    repo = pname;
    rev = "v${version}";
    sha256 = "0xh6y831lf2rfwbpq82nh8ra9a745xrqrp7qd7hczw2pgwaqh44v";
  };

  # Patch layer library_path to use absolute path to libvkbasalt.so
  # and rename layer in 32bit package so it can be installed alongside
  # the 64bit package
  postPatch = ''
    substituteInPlace config/vkBasalt.json \
      --replace libvkbasalt.so "$out/lib${lib.optionalString stdenv.is32bit "32"}/libvkbasalt.so"
  '' + lib.optionalString stdenv.is32bit ''
    substituteInPlace config/vkBasalt.json \
      --replace VK_LAYER_VKBASALT_post_processing \
                VK_LAYER_VKBASALT_post_processing_32
  '';

  nativeBuildInputs = [ glslang meson ninja pkg-config ];
  buildInputs = [ libX11 ];

  # Rename files in 32bit package so it can be installed alongside
  # the 64bit package
  postInstall = lib.optionalString stdenv.is32bit ''
    mv "$out/lib" "$out/lib32"
    mv "$out/share/vulkan/implicit_layer.d/vkBasalt.json" \
      "$out/share/vulkan/implicit_layer.d/vkBasalt32.json"
  '';

  meta = with lib; {
    description = "A Vulkan post processing layer for Linux";
    homepage = "https://github.com/DadSchoorse/vkBasalt";
    license = licenses.zlib;
    maintainers = with maintainers; [ metadark ];
    platforms = platforms.linux;
  };
}
