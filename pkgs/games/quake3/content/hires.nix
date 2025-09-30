{
  stdenv,
  lib,
  fetchzip,
  fetchurl,
  fetchFromGitHub,
  libarchive,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quake3hires";
  version = "unstable-2020-01-20"; # Unknown version, used the date of web.archive.org capture.

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
    url = "https://web.archive.org/web/20250310093216/https://fmt3.dl.dbolical.com/dl/2018/11/06/q3a-hqq-v37.zip?st=0XzNnNvOYWrJAi_6AB3mKw==&e=1741602736";
    hash = "sha256-0nAXkrf4ahlct75TgO18PjuT9IkH8fpDhtTflJfPpPM=";
  };
  # https://www.moddb.com/mods/cz45modbundle/addons/cz45-q3a-weapon-model-remake-v10
  # https://www.moddb.com/downloads/mirror/255463/130/9de70b5dc7ebb1baa44acf91458b04f9/
  # this is only part of the mod, only the weapons skins
  # url = "https://github.com/diegoulloao/ioquake3-mac-install/raw/master/extras/hd-weapons.pk3";
  hd-weapons = fetchurl {
    name = "czq3hdweaprem_v10.zip";
    url = "https://web.archive.org/web/20250310101737/https://fmt1.dl.dbolical.com/dl/2023/08/13/czq3hdweaprem_v10.zip?st=XBoRCpVmvTYtc60xxi36VQ==&e=1741605457";
    hash = "sha256-pL7MsEFsKJV+a+z45Ns16SPdQB3i2D6T3x7tBqWtm1s=";
  };

  # According to the @diegoulloao (see https://github.com/diegoulloao/ioquake3-mac-install/issues/23#issuecomment-2817031996)
  # quake3-live-sounds.pk3 is likely a custom repack from https://www.moddb.com/addons/quake-live-announcers-pack
  # zpack-weapons.pk3 is an amalgamation of multiple mods, where he can't recall which ones he used exactly.
  # It still makes him the authorative source for these file.
  ioquake3_mac = fetchFromGitHub {
    owner = "diegoulloao";
    repo = "ioquake3-mac-install";
    rev = "3a767ff0131742ec517fd5f13ddca16dee91927d";
    hash = "sha256-uY3pybCnQ7lZatP3s9AiT779/4xj8N3R4qx8V6991aM=";
  };

  buildCommand = ''
    mkdir -p $out/baseq3
    install -Dm444 $src/xcsv_bq3hi-res.pk3 $out/baseq3/xcsv_bq3hi-res.pk3
    install -Dm444 ${finalAttrs.extra-pack-resolution} $out/baseq3/pak9hqq37test20181106.pk3

    bsdunzip ${finalAttrs.hd-weapons}
    install -Dm444 zzczhdwr1.pk3 $out/baseq3/zzczhdwr1.pk3
    # https://github.com/diegoulloao/ioquake3-mac-install takes only the first file, following his lead for now
    # install -Dm444 zzczhdwr2.pk3 $out/baseq3/zzczhdwr2.pk3
    # install -Dm444 zzczhdwr3.pk3 $out/baseq3/zzczhdwr3.pk3

    install -Dm444 ${finalAttrs.ioquake3_mac}/extras/quake3-live-sounds.pk3 $out/baseq3/quake3-live-sounds.pk3
    install -Dm444 ${finalAttrs.ioquake3_mac}/extras/zpack-weapons.pk3 $out/baseq3/zpack-weapons.pk3
  '';

  preferLocalBuild = true;

  meta = with lib; {
    description = "Quake 3 high-resolution textures";
    license = licenses.cc0;
    platforms = platforms.all;
    maintainers = with maintainers; [ rvolosatovs ];
  };
})
