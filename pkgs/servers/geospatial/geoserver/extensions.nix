# DO *NOT* MODIFY THE LINES CONTAINING "hash = ..." OR "version = ...".
# THEY ARE GENERATED. SEE ./update.sh.
{ fetchzip, libjpeg, netcdf, pkgs, stdenv }:

let
  mkGeoserverExtension = { name, version, hash, buildInputs ? [ ] }: stdenv.mkDerivation {
    pname = "geoserver-${name}-extension";
    inherit buildInputs version;

    src = fetchzip {
      url = "mirror://sourceforge/geoserver/GeoServer/${version}/extensions/geoserver-${version}-${name}-plugin.zip";
      inherit hash;
      # We expect several files.
      stripRoot = false;
    };

    installPhase = ''
      runHook preInstall

      DIR=$out/share/geoserver/webapps/geoserver/WEB-INF/lib
      mkdir -p $DIR
      cp -r $src/* $DIR

      runHook postInstall
    '';
  };
in

{
  app-schema = mkGeoserverExtension {
    name = "app-schema";
    version = "2.24.2"; # app-schema
    hash = "sha256-nwZ+gZZ38nrKmIqe2Wjg8rkh9cq6TFaxjkwS/lw8720="; # app-schema
  };

  authkey = mkGeoserverExtension {
    name = "authkey";
    version = "2.24.2"; # authkey
    hash = "sha256-R2dL1xAw7PZTAp7asoulfOPWodRD7TnOu8mnSrwxL8I="; # authkey
  };

  cas = mkGeoserverExtension {
    name = "cas";
    version = "2.24.2"; # cas
    hash = "sha256-oTM+ipYuIefxVFUG7ifNE08GkYbuHkt83PtrOHRw40w="; # cas
  };

  charts = mkGeoserverExtension {
    name = "charts";
    version = "2.24.2"; # charts
    hash = "sha256-w9e8Ra0iuhtQ45De1T3wztis6ZLey5LuhpmCadbpCp4="; # charts
  };

  control-flow = mkGeoserverExtension {
    name = "control-flow";
    version = "2.24.2"; # control-flow
    hash = "sha256-XY9YwiMgEay/GhLt6IJQ0gdiVxA0abg/qrnYNW3wiO8="; # control-flow
  };

  css = mkGeoserverExtension {
    name = "css";
    version = "2.24.2"; # css
    hash = "sha256-GDoRcM8Nx3fZuWgzIHM1vSXLMaCJO3j7/cDmRl7BS2U="; # css
  };

  csw = mkGeoserverExtension {
    name = "csw";
    version = "2.24.2"; # csw
    hash = "sha256-Ir/ebw87DV1zSLJIN3sMEwMAqfD9rZ3oKvAM62BNWcE="; # csw
  };

  csw-iso = mkGeoserverExtension {
    name = "csw-iso";
    version = "2.24.2"; # csw-iso
    hash = "sha256-j0rVy5JRwGTs+8esOpMPc79ICccwwtD47vOFsunZAkE="; # csw-iso
  };

  db2 = mkGeoserverExtension {
    name = "db2";
    version = "2.24.2"; # db2
    hash = "sha256-LKOAdKU+0TJdaxUbluXcxzgJw2fvhkqVjYs+d2c84uk="; # db2
  };

  # Needs wps extension.
  dxf = mkGeoserverExtension {
    name = "dxf";
    version = "2.24.2"; # dxf
    hash = "sha256-Et4nCPH6xUChfKRZ35u3/VduEQwCOKeKQXVZZcgJRWc="; # dxf
  };

  excel = mkGeoserverExtension {
    name = "excel";
    version = "2.24.2"; # excel
    hash = "sha256-Nm4mayt8ofwpiRD5FDbsubrHIzfaOBW+Nv8wUVaIPws="; # excel
  };

  feature-pregeneralized = mkGeoserverExtension {
    name = "feature-pregeneralized";
    version = "2.24.2"; # feature-pregeneralized
    hash = "sha256-56HA4L1Vfh5Q45lRhjsYfq816YYNkJLmovngF0+3Vbk="; # feature-pregeneralized
  };

  # Note: The extension name ("gdal") clashes with pkgs.gdal.
  gdal = mkGeoserverExtension {
    name = "gdal";
    version = "2.24.2"; # gdal
    buildInputs = [ pkgs.gdal ];
    hash = "sha256-KLIlEUmYUIXAikW+y3iQzGZPpW0N+9FuPTst23Nf9Y4="; # gdal
  };

  # Throws "java.io.FileNotFoundException: URL [jar:file:/nix/store/.../WEB-INF/lib/gs-geofence-server-2.24.1.jar!/geofence-default-override.properties] cannot be resolved to absolute file path because it does not reside in the file system: jar:file:/nix/store/.../WEB-INF/lib/gs-geofence-server-2.24.1.jar!/geofence-default-override.properties" but seems to work out of the box.
  #geofence = mkGeoserverExtension {
  #  name = "geofence";
  #  version = "2.24.2"; # geofence
  #  hash = "sha256-5MRUKiC23/XlFr7X4zpsAoDR4JGtZujFnUmtcRlG+9w="; # geofence
  #};

  #geofence-server = mkGeoserverExtension {
  #  name = "geofence-server";
  #  version = "2.24.2"; # geofence-server
  #  hash = "sha256-MyDQSb7IZ8cTpO9+rV0PdZNHRvIDIr04+HNhyMpx81I="; # geofence-server
  #};

  #geofence-wps = mkGeoserverExtension {
  #  name = "geofence-wps";
  #  version = "2.24.2"; # geofence-wps
  #  hash = "sha256-uLii8U3UAiF/MQjABBAfHbnXTlf+iYsEOy4kadqc6+k="; # geofence-wps
  #};

  geopkg-output = mkGeoserverExtension {
    name = "geopkg-output";
    version = "2.24.2"; # geopkg-output
    hash = "sha256-NzsozGYoGOoekX+wY0d5d8I0JefHgSDb/HuEPzwX+YE="; # geopkg-output
  };

  grib = mkGeoserverExtension {
    name = "grib";
    version = "2.24.2"; # grib
    hash = "sha256-9i+aqQM4GnRXfIjg2R2/NkkQAF9YxNRfbMp7mGO4BgE="; # grib
    buildInputs = [ netcdf ];
  };

  gwc-s3 = mkGeoserverExtension {
    name = "gwc-s3";
    version = "2.24.2"; # gwc-s3
    hash = "sha256-fesKzbSnNHxgjwuXghLBJhUkvM2HeCOZY9V0AAiZVWk="; # gwc-s3
  };

  h2 = mkGeoserverExtension {
    name = "h2";
    version = "2.24.2"; # h2
    hash = "sha256-cMPdNh7Bp7aiAAiuB5E8dDWCuUkd89xQXJbvoYN5Oyk="; # h2
  };

  iau = mkGeoserverExtension {
    name = "iau";
    version = "2.24.2"; # iau
    hash = "sha256-yIqw1ur2e3haPMXGOFgFdNLguzhMMytcg9aweaBFq5U="; # iau
  };

  importer = mkGeoserverExtension {
    name = "importer";
    version = "2.24.2"; # importer
    hash = "sha256-/u5m4ljr7kEnRl9sOuYcS8913uPzJjDCXmRiWh7YS2c="; # importer
  };

  inspire = mkGeoserverExtension {
    name = "inspire";
    version = "2.24.2"; # inspire
    hash = "sha256-3N1LUEu2q3Vy2verkJd9Fiem8V9W0KvsnSTwooO0M6E="; # inspire
  };

  # Needs Kakadu plugin from
  # https://github.com/geosolutions-it/imageio-ext
  #jp2k = mkGeoserverExtension {
  #  name = "jp2k";
  #  version = "2.24.2"; # jp2k
  #  hash = "sha256-ZjPDCMzaXegrzmbI9vwjTt0Osbjjl/31sffU65PPJ3k="; # jp2k
  #};

  libjpeg-turbo = mkGeoserverExtension {
    name = "libjpeg-turbo";
    version = "2.24.2"; # libjpeg-turbo
    hash = "sha256-aPKXE8STYG0h5OtxrOoTvXagUCBmb7nmEV8ckLRq6GM="; # libjpeg-turbo
    buildInputs = [ libjpeg.out ];
  };

  mapml = mkGeoserverExtension {
    name = "mapml";
    version = "2.24.2"; # mapml
    hash = "sha256-vjNoLZEM2CMmxL2JPO0r9PColReWmFdVjMkDxbyrSGg="; # mapml
  };

  mbstyle = mkGeoserverExtension {
    name = "mbstyle";
    version = "2.24.2"; # mbstyle
    hash = "sha256-zvfoAoVT8hXUETn/GkceP8vLSA8iNUXivXjQUyIJDEs="; # mbstyle
  };

  metadata = mkGeoserverExtension {
    name = "metadata";
    version = "2.24.2"; # metadata
    hash = "sha256-A6Gai/ExL9FSUQOuUwxqpRcaVtn4H1VwBaAKXMNm6Fg="; # metadata
  };

  mongodb = mkGeoserverExtension {
    name = "mongodb";
    version = "2.24.2"; # mongodb
    hash = "sha256-R9dp/uOIX7KBp4c2676NXQupqoRahxKkufjCr6sQaA0="; # mongodb
  };

  monitor = mkGeoserverExtension {
    name = "monitor";
    version = "2.24.2"; # monitor
    hash = "sha256-IB9/4755ePtL/CWIOd28dOyBG6cmddQnhZKVQMQFeIE="; # monitor
  };

  mysql = mkGeoserverExtension {
    name = "mysql";
    version = "2.24.2"; # mysql
    hash = "sha256-8y3N7+KgA9R5JIw1YuHmTmzK6H2c56469KUTrRpqP4g="; # mysql
  };

  netcdf = mkGeoserverExtension {
    name = "netcdf";
    version = "2.24.2"; # netcdf
    hash = "sha256-uAhJTCKn/00zDUGtgyYd1v8KxXj1N+vAAosBjQG3rBk="; # netcdf
    buildInputs = [ netcdf ];
  };

  netcdf-out = mkGeoserverExtension {
    name = "netcdf-out";
    version = "2.24.2"; # netcdf-out
    hash = "sha256-wMFx+BnEcLy1x9j0K+du7hG9wC+EzA4E4AVjIsyXO3A="; # netcdf-out
    buildInputs = [ netcdf ];
  };

  ogr-wfs = mkGeoserverExtension {
    name = "ogr-wfs";
    version = "2.24.2"; # ogr-wfs
    buildInputs = [ pkgs.gdal ];
    hash = "sha256-jMnc0OnrKHFegEIPtyAG92fC8cLa/X1UUdTmeDyUxSI="; # ogr-wfs
  };

  # Needs ogr-wfs extension.
  ogr-wps = mkGeoserverExtension {
    name = "ogr-wps";
    version = "2.24.2"; # ogr-wps
    # buildInputs = [ pkgs.gdal ];
    hash = "sha256-O0MKOCEV5AjYUg4LL0UAV0KBHg1alOK7WEdEyikqpTs="; # ogr-wps
  };

  oracle = mkGeoserverExtension {
    name = "oracle";
    version = "2.24.2"; # oracle
    hash = "sha256-OIvwpGt/9jtKAeP7LK/hTZDVbKQnjVGTXDy5q/zVU2k="; # oracle
  };

  params-extractor = mkGeoserverExtension {
    name = "params-extractor";
    version = "2.24.2"; # params-extractor
    hash = "sha256-z6hMGCHB0I3DS05NvdSmVMfPKNA/1jhx8Mmb6odL6RU="; # params-extractor
  };

  printing = mkGeoserverExtension {
    name = "printing";
    version = "2.24.2"; # printing
    hash = "sha256-nDkT9x6Va5SNSf8x7OEu7NqQ6qFSJhPavg6eUo5D4HA="; # printing
  };

  pyramid = mkGeoserverExtension {
    name = "pyramid";
    version = "2.24.2"; # pyramid
    hash = "sha256-HM2ItB34+CHNzhoH3X3Kh1iVNMb+AimvdHrgHHh5SJc="; # pyramid
  };

  querylayer = mkGeoserverExtension {
    name = "querylayer";
    version = "2.24.2"; # querylayer
    hash = "sha256-7WtAsisMJBpRZqU0nfr4orp36uBmnvat2+DlbnGCjVg="; # querylayer
  };

  sldservice = mkGeoserverExtension {
    name = "sldservice";
    version = "2.24.2"; # sldservice
    hash = "sha256-m3QJP/u6HZmO0p8d++8EKXXxtkbMDmBFFCzBPctPV5A="; # sldservice
  };

  sqlserver = mkGeoserverExtension {
    name = "sqlserver";
    version = "2.24.2"; # sqlserver
    hash = "sha256-ZwsO1Yxb3OWCLtYI30l3jnMrAbPI7v0XTGcasJPN1Y8="; # sqlserver
  };

  vectortiles = mkGeoserverExtension {
    name = "vectortiles";
    version = "2.24.2"; # vectortiles
    hash = "sha256-fQ9qSIHplxt57n45w4MN4e5AFdU8nmtvQ/vTeL/cdzQ="; # vectortiles
  };

  wcs2_0-eo = mkGeoserverExtension {
    name = "wcs2_0-eo";
    version = "2.24.2"; # wcs2_0-eo
    hash = "sha256-q0cXVjOBmX4vYwzf+3LjsYf9rPAIeCxnOZZadfNlLF0="; # wcs2_0-eo
  };

  web-resource = mkGeoserverExtension {
    name = "web-resource";
    version = "2.24.2"; # web-resource
    hash = "sha256-v/SnNV6JnWPoYUSFowXFDDuhjZC8b1iPtDeMG8mWqG4="; # web-resource
  };

  wmts-multi-dimensional = mkGeoserverExtension {
    name = "wmts-multi-dimensional";
    version = "2.24.2"; # wmts-multi-dimensional
    hash = "sha256-ASSGBqTpq9Tk1R3oBTBoi6L1tsXIJpJyez3LXBPmjd8="; # wmts-multi-dimensional
  };

  wps = mkGeoserverExtension {
    name = "wps";
    version = "2.24.2"; # wps
    hash = "sha256-KJa0yWqO/qyY59U9NMK5/V4EskIqEbe9XnSvGRvODHU="; # wps
  };

  # Needs hazelcast (https://github.com/hazelcast/hazelcast (?)) which is not
  # available in nixpgs as of 2024/01.
  #wps-cluster-hazelcast = mkGeoserverExtension {
  #  name = "wps-cluster-hazelcast";
  #  version = "2.24.2"; # wps-cluster-hazelcast
  #  hash = "sha256-PQcX3AVJy3DluAL4b5vcWvLl0fYLBq+F8cKsvJ/WOyE="; # wps-cluster-hazelcast
  #};

  wps-download = mkGeoserverExtension {
    name = "wps-download";
    version = "2.24.2"; # wps-download
    hash = "sha256-cjVbQ1R2uit/29axZsu88ZiMuwY7mmR5x8XNb9qX8aM="; # wps-download
  };

  # Needs Postrgres configuration or similar.
  # See https://docs.geoserver.org/main/en/user/extensions/wps-jdbc/index.html
  wps-jdbc = mkGeoserverExtension {
    name = "wps-jdbc";
    version = "2.24.2"; # wps-jdbc
    hash = "sha256-dJUnh8HZmlu5aqVeFxyR3A8fbXYqbgIqPxIENq4rhfs="; # wps-jdbc
  };

  ysld = mkGeoserverExtension {
    name = "ysld";
    version = "2.24.2"; # ysld
    hash = "sha256-GLUioofwqoGUw7JQeEhzBG1SRwGUzwqjKvhkOt4TUVw="; # ysld
  };

}
