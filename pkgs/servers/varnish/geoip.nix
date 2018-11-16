{ stdenv, fetchpatch, fetchFromGitHub, autoreconfHook, pkgconfig, varnish, geoip, docutils }:

stdenv.mkDerivation rec {
  version = "1.0.2";
  name = "${varnish.name}-geoip-${version}";

  src = fetchFromGitHub {
    owner = "varnish";
    repo = "libvmod-geoip";
    rev = "libvmod-geoip-${version}";
    sha256 = "1gmadayqh3dais14c4skvd47w8h4kyifg7kcw034i0777z5hfpyn";
  };

  patches = [
    # IPv6 support
    (fetchpatch {
      url = https://github.com/volth/libvmod-geoip-1/commit/0966fe8.patch;
      sha256 = "053im8h2y8qzs37g95ksr00sf625p23r5ps1j0a2h4lfg70vf4ry";
    })
  ];

  nativeBuildInputs = [ autoreconfHook pkgconfig docutils ];
  buildInputs = [ varnish geoip ];
  configureFlags = [ "VMOD_DIR=$(out)/lib/varnish/vmods" ];

  meta = with stdenv.lib; {
    description = "GeoIP Varnish module by Varnish Software";
    homepage = https://github.com/varnish/libvmod-geoip;
    inherit (varnish.meta) license platforms maintainers;
  };
}
