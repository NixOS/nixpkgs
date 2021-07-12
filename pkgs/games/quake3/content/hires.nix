{ stdenv, lib, fetchzip }:

stdenv.mkDerivation {
  pname = "quake3hires";
  version = "2020-01-20"; # Unknown version, used the date of web.archive.org capture.

  src = fetchzip {
    url = "https://web.archive.org/web/20200120024216/http://ioquake3.org/files/xcsv_hires.zip";
    sha256 = "09vhrray8mh1ic2qgcwv0zlmsnz789y32dkkvrz1vdki4yqkf717";
    stripRoot = false;
  };

  buildCommand = ''
    mkdir -p $out/baseq3
    install -Dm444 $src/xcsv_bq3hi-res.pk3 $out/baseq3/xcsv_bq3hi-res.pk3
  '';

  preferLocalBuild = true;

  meta = with lib; {
    description = "Quake 3 high-resolution textures";
    license = licenses.cc0;
    platforms = platforms.all;
    maintainers = with maintainers; [ rvolosatovs ];
  };
}
