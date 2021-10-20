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
, vkBasalt32
}:

stdenv.mkDerivation rec {
  pname = "vkBasalt";
  version = "0.3.2.4";

  src = fetchFromGitHub {
    owner = "DadSchoorse";
    repo = pname;
    rev = "v${version}";
    sha256 = "01iplj6dlw2vl35hyci5m5yp8jmzcwng6c3jk3wn97jpv6m3hjqz";
  };

  nativeBuildInputs = [ glslang meson ninja pkg-config ];
  buildInputs = [ libX11 spirv-headers vulkan-headers ];
  mesonFlags = [ "-Dappend_libdir_vkbasalt=true" ];

  # Include 32bit layer in 64bit build
  postInstall = lib.optionalString (stdenv.hostPlatform.system == "x86_64-linux") ''
    ln -s ${vkBasalt32}/share/vulkan/implicit_layer.d/vkBasalt.json \
      "$out/share/vulkan/implicit_layer.d/vkBasalt32.json"
  '';

  meta = with lib; {
    description = "A Vulkan post processing layer for Linux";
    homepage = "https://github.com/DadSchoorse/vkBasalt";
    license = licenses.zlib;
    maintainers = with maintainers; [ kira-bruneau ];
    platforms = platforms.linux;
  };
}
