{ fetchgit, stdenv, lib, autoreconfHook, pkg-config, libupnpp, libnpupnp, curl, expat, mpd_clientlib, libmicrohttpd, jsoncpp
, makeWrapper, python
, recoll
, mutagen
}:

let
  recoll'= recoll.override { python3Packages = python.pkgs; };
  mutagen'= python.pkgs.mutagen;
in

stdenv.mkDerivation rec {
  pname = "upmpdcli";
  version = "1.6.2";

  src = fetchgit {
    url = "https://framagit.org/medoc92/upmpdcli.git";
    rev = "upmpdcli-v${version}";
    sha256 = "sha256-ik5N1OORyUqI9FxlYB6XT4ao2rtgYKDwvdeD0n4p8iY=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config libupnpp libnpupnp curl expat mpd_clientlib libmicrohttpd jsoncpp
    makeWrapper python recoll'
  ];

  enableParallelBuilding = true;

  postInstall = ''
    patchShebangs $out
    wrapProgram $out/share/upmpdcli/cdplugins/uprcl/uprcl-app.py \
      --prefix PYTHONPATH : $out/share/upmpdcli/cdplugins/uprcl:$out/share/upmpdcli/cdplugins/pycommon:${recoll'}/${python.sitePackages}:${mutagen'}/${python.sitePackages}
  '';

  meta = {
    description = "UPnP renderer front-end for MPD";

    license = "BSD-style";

    homepage = https://www.lesbonscomptes.com/upmpdcli;
    platforms = lib.platforms.unix;
  };
}
