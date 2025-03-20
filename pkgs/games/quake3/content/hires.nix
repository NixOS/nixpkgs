{
  stdenv,
  lib,
  fetchzip,
  fetchurl,
  libarchive,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quake3hires";
  version = "2020-01-20"; # Unknown version, used the date of web.archive.org capture.

  nativeBuildInputs = [
    libarchive
  ];

  src = fetchzip {
    url = "https://web.archive.org/web/20200120024216/http://ioquake3.org/files/xcsv_hires.zip";
    sha256 = "09vhrray8mh1ic2qgcwv0zlmsnz789y32dkkvrz1vdki4yqkf717";
    stripRoot = false;
  };

  # https://www.moddb.com/mods/high-quality-quake
  # TODO check if that file needs renaming to something that starts with z_* so it actually overrides anything in pak0.pk3
  extra-pack-resolution = fetchurl {
    # url = "https://github.com/diegoulloao/ioquake3-mac-install/raw/master/extras/extra-pack-resolution.pk3";
    url = "https://web.archive.org/web/20250310093216/https://fmt3.dl.dbolical.com/dl/2018/11/06/q3a-hqq-v37.zip?st=0XzNnNvOYWrJAi_6AB3mKw==&e=1741602736";
    sha256 = "sha256-0nAXkrf4ahlct75TgO18PjuT9IkH8fpDhtTflJfPpPM=";
  };

  # backport of sound files from quake 3 live
  quake3-live-sounds = fetchurl {
    url = "https://github.com/diegoulloao/ioquake3-mac-install/blob/3a767ff0131742ec517fd5f13ddca16dee91927d/extras/quake3-live-sounds.pk3";
    sha256 = "sha256-0vODIpA3/5BPNno5PKhc/ISI2rFYXYyumKdzUFyXn3M=";
  };
  # https://www.moddb.com/mods/cz45modbundle/addons/cz45-q3a-weapon-model-remake-v10
  # https://www.moddb.com/downloads/mirror/255463/130/9de70b5dc7ebb1baa44acf91458b04f9/
  # this is only part of the mod, only the weapons skins
  # url = "https://github.com/diegoulloao/ioquake3-mac-install/raw/master/extras/hd-weapons.pk3";
  hd-weapons = fetchurl {
    name = "czq3hdweaprem_v10.zip";
    url = "https://web.archive.org/web/20250310101737/https://fmt1.dl.dbolical.com/dl/2023/08/13/czq3hdweaprem_v10.zip?st=XBoRCpVmvTYtc60xxi36VQ==&e=1741605457";
    sha256 = "sha256-pL7MsEFsKJV+a+z45Ns16SPdQB3i2D6T3x7tBqWtm1s=";
  };
  zpack-weapons = fetchurl {
    url = "https://github.com/diegoulloao/ioquake3-mac-install/blob/3a767ff0131742ec517fd5f13ddca16dee91927d/extras/zpack-weapons.pk3";
    sha256 = "sha256-RSK0wZvNqrC3lTT6jhSmEgGL6TiaFz+f+YoI7lr7ckA=";
  };

  buildCommand = ''
    mkdir -p $out/baseq3
    install -Dm444 $src/xcsv_bq3hi-res.pk3 $out/baseq3/xcsv_bq3hi-res.pk3
    install -Dm444 ${finalAttrs.extra-pack-resolution} $out/baseq3/pak9hqq37test20181106.pk3
    install -Dm444 ${finalAttrs.quake3-live-sounds} $out/baseq3/quake3-live-sounds.pk3

    bsdunzip ${finalAttrs.hd-weapons}
    install -Dm444 zzczhdwr1.pk3 $out/baseq3/zzczhdwr1.pk3
    # https://github.com/diegoulloao/ioquake3-mac-install takes only the first file, following his lead for now
    # install -Dm444 zzczhdwr2.pk3 $out/baseq3/zzczhdwr2.pk3
    # install -Dm444 zzczhdwr3.pk3 $out/baseq3/zzczhdwr3.pk3

    install -Dm444 ${finalAttrs.zpack-weapons} $out/baseq3/zpack-weapons.pk3
  '';

  preferLocalBuild = true;

  meta = with lib; {
    description = "Quake 3 high-resolution textures";
    license = licenses.cc0;
    platforms = platforms.all;
    maintainers = with maintainers; [ rvolosatovs ];
  };
})
