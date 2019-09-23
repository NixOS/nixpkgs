{ stdenv, fetchurl, unzip }:

# Look for the correct urls for build_front and build_api artifacts on the tags page of the project : https://dev.funkwhale.audio/funkwhale/funkwhale/pipelines?scope=tags
# Attention : do not use the url "https://dev.funkwhale.audio/funkwhale/funkwhale/-/jobs/artifacts/${release}/download?job=" : it is not guaranteed to be stable

let
  release = "0.20.0";
  srcs = {
    api = fetchurl {
      url = https://dev.funkwhale.audio/funkwhale/funkwhale/-/jobs/31311/artifacts/download;
      name =  "api.zip";
      sha256 = "1v8v5rha21ksdqnj73qkvc35mxal82hypxa5gnf82y1cjk2lp4w7";
    };
    frontend = fetchurl {
      url = https://dev.funkwhale.audio/funkwhale/funkwhale/-/jobs/31308/artifacts/download;
      name =  "frontend.zip";
      sha256 = "02pc6j83sn5l8wz7i2r649pff3gs5021isx9d5l9xsb5cndkq0b4";
    };
  };
in stdenv.mkDerivation {
  name = "funkwhale";
  version = "${release}";
  src = srcs.api;
  nativeBuildInputs = [ unzip ];
  postPatch = ''
    substituteInPlace requirements/base.txt \
      --replace "django-cleanup==3.2.0" django-cleanup
  '';

  installPhase = ''
    mkdir $out
    cp -R ./* $out
    unzip ${srcs.frontend} -d $out
    mv $out/front/ $out/front_tmp
    mv $out/front_tmp/dist $out/front
    rmdir $out/front_tmp
    '';

  meta = with stdenv.lib; {
    description = "A modern, convivial and free music server";
    homepage = https://funkwhale.audio/;
    license = licenses.agpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mmai ];
  };
 }
