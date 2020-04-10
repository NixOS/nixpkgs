{ stdenv, fetchFromGitHub
, libdrm, json_c, pciutils
, meson, ninja, pkgconfig
}:

stdenv.mkDerivation rec {
  pname = "drm_info";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "ascent12";
    repo = "drm_info";
    rev = "v${version}";
    sha256 = "0s4zp8xz21zcpinbcwdvg48rf0xr7rs0dqri28q093vfmllsk36f";
  };

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = [ libdrm json_c pciutils ];

  meta = with stdenv.lib; {
    description = "Small utility to dump info about DRM devices.";
    homepage = "https://github.com/ascent12/drm_info";
    license = licenses.mit;
    maintainers = with maintainers; [ tadeokondrak ];
    platforms = platforms.linux;
  };
}
