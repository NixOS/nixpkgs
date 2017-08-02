{ stdenv, fetchurl, pkgconfig

# Optional Dependencies
, alsaLib ? null, db ? null, libuuid ? null, libffado ? null, celt ? null
}:

let
  shouldUsePkg = pkg: if pkg != null && stdenv.lib.any (x: x == stdenv.system) pkg.meta.platforms then pkg else null;

  optAlsaLib = shouldUsePkg alsaLib;
  optDb = shouldUsePkg db;
  optLibuuid = shouldUsePkg libuuid;
  optLibffado = shouldUsePkg libffado;
  optCelt = shouldUsePkg celt;
in
stdenv.mkDerivation rec {
  name = "jack1-${version}";
  version = "0.124.1";

  src = fetchurl {
    url = "http://jackaudio.org/downloads/jack-audio-connection-kit-${version}.tar.gz";
    sha256 = "1mk1wnx33anp6haxfjjkfhwbaknfblsvj35nxvz0hvspcmhdyhpb";
  };
  
  configureFlags = ''
    ${if (optLibffado != null) then "--enable-firewire" else ""}
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ optAlsaLib optDb optLibffado optCelt ];
  propagatedBuildInputs = [ optLibuuid ];
  
  meta = with stdenv.lib; {
    description = "JACK audio connection kit";
    homepage = http://jackaudio.org;
    license = "GPL";
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
