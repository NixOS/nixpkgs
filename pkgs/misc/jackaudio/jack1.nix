{ stdenv, fetchurl, pkgconfig

# Optional Dependencies
, alsaLib ? null, db ? null, libuuid ? null, libffado ? null, celt ? null
}:

let
  shouldUsePkg = pkg: if pkg != null && pkg.meta.available then pkg else null;

  optAlsaLib = shouldUsePkg alsaLib;
  optDb = shouldUsePkg db;
  optLibuuid = shouldUsePkg libuuid;
  optLibffado = shouldUsePkg libffado;
  optCelt = shouldUsePkg celt;
in
stdenv.mkDerivation rec {
  name = "jack1-${version}";
  version = "0.125.0";

  src = fetchurl {
    url = "http://jackaudio.org/downloads/jack-audio-connection-kit-${version}.tar.gz";
    sha256 = "0i6l25dmfk2ji2lrakqq9icnwjxklgcjzzk65dmsff91z2zva5rm";
  };
  
  configureFlags = [
    (stdenv.lib.enableFeature (optLibffado != null) "firewire")
  ];

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
