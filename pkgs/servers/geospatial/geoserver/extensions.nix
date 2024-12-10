# DO *NOT* MODIFY THE LINES CONTAINING "hash = ..." OR "version = ...".
# THEY ARE GENERATED. SEE ./update.sh.
{
  fetchzip,
  libjpeg,
  netcdf,
  pkgs,
  stdenv,
}:

let
  mkGeoserverExtension =
    {
      name,
      version,
      hash,
      buildInputs ? [ ],
    }:
    stdenv.mkDerivation {
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
    version = "2.25.2"; # app-schema
    hash = "sha256-qOBS6IfuXbTT9YHucAGedVfJ5xsVDTYP+9NLY5qaDWU="; # app-schema
  };

  authkey = mkGeoserverExtension {
    name = "authkey";
    version = "2.25.2"; # authkey
    hash = "sha256-GJSD3ULjDkxp3Ex6RSrafN6BXvglEbq9zNZZnEZYgL0="; # authkey
  };

  cas = mkGeoserverExtension {
    name = "cas";
    version = "2.25.2"; # cas
    hash = "sha256-vrYCPMVK9BQiGa7L25bzSGQuwA+kEf6BGS5Sv49N9bE="; # cas
  };

  charts = mkGeoserverExtension {
    name = "charts";
    version = "2.25.2"; # charts
    hash = "sha256-QXb3tzOabBejIGvys7DRj/zZPewcZjjJPCn99bvbpjM="; # charts
  };

  control-flow = mkGeoserverExtension {
    name = "control-flow";
    version = "2.25.2"; # control-flow
    hash = "sha256-JNOs103SMHzG2I46kXDKV3f6xfGpDhXpVY+jR4IDKFw="; # control-flow
  };

  css = mkGeoserverExtension {
    name = "css";
    version = "2.25.2"; # css
    hash = "sha256-lN1QfCCMVgVxVKmZRyQj6muFOCvoHHxNETOux8sZeMM="; # css
  };

  csw = mkGeoserverExtension {
    name = "csw";
    version = "2.25.2"; # csw
    hash = "sha256-rpAVzit0DSjgopL//nK0feejTSfnoTIyaKLz6vpajrs="; # csw
  };

  csw-iso = mkGeoserverExtension {
    name = "csw-iso";
    version = "2.25.2"; # csw-iso
    hash = "sha256-nsieTEMrysZt9Jz3dWTvfCKh41DrkrJ1sTxk4Iv/kEY="; # csw-iso
  };

  db2 = mkGeoserverExtension {
    name = "db2";
    version = "2.25.2"; # db2
    hash = "sha256-9S1QafqRlCtM9N/mEehRbko5kNgjGe5BJen98ZcqOt8="; # db2
  };

  # Needs wps extension.
  dxf = mkGeoserverExtension {
    name = "dxf";
    version = "2.25.2"; # dxf
    hash = "sha256-FcXcJwEm1Z3M0OUuR1p/PGbvbQ0zf4v0ruL/765xD+E="; # dxf
  };

  excel = mkGeoserverExtension {
    name = "excel";
    version = "2.25.2"; # excel
    hash = "sha256-2QEG6u3luAgCFvC1GIQQX7KVNz7KSllx+XMiHUBzH3c="; # excel
  };

  feature-pregeneralized = mkGeoserverExtension {
    name = "feature-pregeneralized";
    version = "2.25.2"; # feature-pregeneralized
    hash = "sha256-ayOQ7ZJ0vBwMfJltPX+ajG9fpxDbn9a+s0W5gAJ2Na0="; # feature-pregeneralized
  };

  # Note: The extension name ("gdal") clashes with pkgs.gdal.
  gdal = mkGeoserverExtension {
    name = "gdal";
    version = "2.25.2"; # gdal
    buildInputs = [ pkgs.gdal ];
    hash = "sha256-CUKqgc/kiNh/kMrvBXiVHrko4MiMexvY7W48NNXXooU="; # gdal
  };

  # Throws "java.io.FileNotFoundException: URL [jar:file:/nix/store/.../WEB-INF/lib/gs-geofence-server-2.24.1.jar!/geofence-default-override.properties] cannot be resolved to absolute file path because it does not reside in the file system: jar:file:/nix/store/.../WEB-INF/lib/gs-geofence-server-2.24.1.jar!/geofence-default-override.properties" but seems to work out of the box.
  #geofence = mkGeoserverExtension {
  #  name = "geofence";
  #  version = "2.25.2"; # geofence
  #  hash = "sha256-HtbLj5hiqjIJU3IIbcvCQgxlan8PLn/xW+0U2FMBrwE="; # geofence
  #};

  #geofence-server = mkGeoserverExtension {
  #  name = "geofence-server";
  #  version = "2.25.2"; # geofence-server
  #  hash = "sha256-o8+9ePnCuWjB0u9QcgJ2sYSMb0+XslROJEZdDJPXg3k="; # geofence-server
  #};

  #geofence-wps = mkGeoserverExtension {
  #  name = "geofence-wps";
  #  version = "2.25.2"; # geofence-wps
  #  hash = "sha256-3VsSgE9crmnbMP9njAlZTMZ8hyBRm5JXTLjSET53lco="; # geofence-wps
  #};

  geopkg-output = mkGeoserverExtension {
    name = "geopkg-output";
    version = "2.25.2"; # geopkg-output
    hash = "sha256-P8DllJYIEIGnzzJeGx+hWpik5Tpo6m+7Ip6QRTZ9Qcs="; # geopkg-output
  };

  grib = mkGeoserverExtension {
    name = "grib";
    version = "2.25.2"; # grib
    hash = "sha256-MByVrJB6WCxiY4/Ljpfx93Lg01/iixgsnp47C0/LmtE="; # grib
    buildInputs = [ netcdf ];
  };

  gwc-s3 = mkGeoserverExtension {
    name = "gwc-s3";
    version = "2.25.2"; # gwc-s3
    hash = "sha256-I38JVvWTc+ernyyIcYAa7vLK4LNbdNihab3wveCyoLM="; # gwc-s3
  };

  h2 = mkGeoserverExtension {
    name = "h2";
    version = "2.25.2"; # h2
    hash = "sha256-Pn3XNTnFn1HQa4V+9FGp4xRWYOKYo7F9TqnPKs7JeNI="; # h2
  };

  iau = mkGeoserverExtension {
    name = "iau";
    version = "2.25.2"; # iau
    hash = "sha256-4PD5DsJgoXfOQ5lf4okx1dW4zRiHSi8geGrqH4axWew="; # iau
  };

  importer = mkGeoserverExtension {
    name = "importer";
    version = "2.25.2"; # importer
    hash = "sha256-o5BHWMu4C7O8VTZWo7LPTtGR47d0opLTf+dQMxTVZzk="; # importer
  };

  inspire = mkGeoserverExtension {
    name = "inspire";
    version = "2.25.2"; # inspire
    hash = "sha256-iQlpq5ZP3Gz9UGXH1hSW7S5Zv1mZHqieTACUX0dP3Vs="; # inspire
  };

  # Needs Kakadu plugin from
  # https://github.com/geosolutions-it/imageio-ext
  #jp2k = mkGeoserverExtension {
  #  name = "jp2k";
  #  version = "2.25.2"; # jp2k
  #  hash = "sha256-0Sh0eM0ZWyCL34IOir7j3gYwyUU7y3+zhIV5y+BJ1NA="; # jp2k
  #};

  libjpeg-turbo = mkGeoserverExtension {
    name = "libjpeg-turbo";
    version = "2.25.2"; # libjpeg-turbo
    hash = "sha256-hXjF7uifk8Tp3z2qLhymQOwIJ8Ml4FN5Qd4s1NP3TPk="; # libjpeg-turbo
    buildInputs = [ libjpeg.out ];
  };

  mapml = mkGeoserverExtension {
    name = "mapml";
    version = "2.25.2"; # mapml
    hash = "sha256-fx8EpGg6ZeuGLuh+PLRNSWgH74MEnIvB4rXw6GVS+60="; # mapml
  };

  mbstyle = mkGeoserverExtension {
    name = "mbstyle";
    version = "2.25.2"; # mbstyle
    hash = "sha256-uQw7wdkZP+1XUjombMxLnZ61DSl8NHyGoEuFy7biDlM="; # mbstyle
  };

  metadata = mkGeoserverExtension {
    name = "metadata";
    version = "2.25.2"; # metadata
    hash = "sha256-3TWMLToHwXn15T1d4v9U76WRjjIJhX12It5DPfuWdLY="; # metadata
  };

  mongodb = mkGeoserverExtension {
    name = "mongodb";
    version = "2.25.2"; # mongodb
    hash = "sha256-Y/myutomkhAMPDjoGrsqEdsHjzI98+514vcKDIJPA2M="; # mongodb
  };

  monitor = mkGeoserverExtension {
    name = "monitor";
    version = "2.25.2"; # monitor
    hash = "sha256-elDVdUT8DdxWGesF9MX+FSYs6thf3RHoUFJJvxGmb/A="; # monitor
  };

  mysql = mkGeoserverExtension {
    name = "mysql";
    version = "2.25.2"; # mysql
    hash = "sha256-mers+ULFC1RSvC2aCs3qbcfmHbkLddriUaDr9wfJ/YA="; # mysql
  };

  netcdf = mkGeoserverExtension {
    name = "netcdf";
    version = "2.25.2"; # netcdf
    hash = "sha256-OJVqwGIhecDwmtmAaJcXbqlwCIASja5sUxBiPoXkrB0="; # netcdf
    buildInputs = [ netcdf ];
  };

  netcdf-out = mkGeoserverExtension {
    name = "netcdf-out";
    version = "2.25.2"; # netcdf-out
    hash = "sha256-0Ym8oVA1wDFqQGaf0VspTX2tCTdI0yTsp7CAmenBL/8="; # netcdf-out
    buildInputs = [ netcdf ];
  };

  ogr-wfs = mkGeoserverExtension {
    name = "ogr-wfs";
    version = "2.25.2"; # ogr-wfs
    buildInputs = [ pkgs.gdal ];
    hash = "sha256-enrc+zGq2brreqQMbCjcnImf7aTZbLbuolK3/y1Icck="; # ogr-wfs
  };

  # Needs ogr-wfs extension.
  ogr-wps = mkGeoserverExtension {
    name = "ogr-wps";
    version = "2.25.2"; # ogr-wps
    # buildInputs = [ pkgs.gdal ];
    hash = "sha256-TCvydQYdtnqH/xudzBOyrvxqFqWke7B4At1f6L7UHO4="; # ogr-wps
  };

  oracle = mkGeoserverExtension {
    name = "oracle";
    version = "2.25.2"; # oracle
    hash = "sha256-1KixJvCpeNc5lN+XSx+FC8D71WcnkO6mG3wYWH3w0c4="; # oracle
  };

  params-extractor = mkGeoserverExtension {
    name = "params-extractor";
    version = "2.25.2"; # params-extractor
    hash = "sha256-MzdJEvHOesJJnLs4fmWFgLjbjUBlc85tvWoHYv0gdjE="; # params-extractor
  };

  printing = mkGeoserverExtension {
    name = "printing";
    version = "2.25.2"; # printing
    hash = "sha256-JwyJYGIcZOaSvkFbJu9TAKVfwu3XwZP7dzewYx5HSsc="; # printing
  };

  pyramid = mkGeoserverExtension {
    name = "pyramid";
    version = "2.25.2"; # pyramid
    hash = "sha256-2LEat5BZgWFQmE68vxirXH+DIUEdVsTf6Ec8F+/6DA8="; # pyramid
  };

  querylayer = mkGeoserverExtension {
    name = "querylayer";
    version = "2.25.2"; # querylayer
    hash = "sha256-VnvfntM3SvMKxAk25Gj3iKqsYSKhLfh+PyyoANqwfq8="; # querylayer
  };

  sldservice = mkGeoserverExtension {
    name = "sldservice";
    version = "2.25.2"; # sldservice
    hash = "sha256-lzOs7MrmAqoJlCK+HxiKAOdlCHuqXa5DU9tilF6cZoo="; # sldservice
  };

  sqlserver = mkGeoserverExtension {
    name = "sqlserver";
    version = "2.25.2"; # sqlserver
    hash = "sha256-EZTcoNfp1iGCBNW3YR4NZpeI+tStcodGE5wQiWfFzno="; # sqlserver
  };

  vectortiles = mkGeoserverExtension {
    name = "vectortiles";
    version = "2.25.2"; # vectortiles
    hash = "sha256-+o8qliiCnRljCXniI+9I7ooU/l1SLEPF9iDtxviKfqY="; # vectortiles
  };

  wcs2_0-eo = mkGeoserverExtension {
    name = "wcs2_0-eo";
    version = "2.25.2"; # wcs2_0-eo
    hash = "sha256-L9jKxivUtwA9Jgfy3E1rQD0+19PrvHxwklDJkAYFRT0="; # wcs2_0-eo
  };

  web-resource = mkGeoserverExtension {
    name = "web-resource";
    version = "2.25.2"; # web-resource
    hash = "sha256-KikKMMZ6vv/qWwn0TCQcNR18MbrJibweu+yvUhQt7vQ="; # web-resource
  };

  wmts-multi-dimensional = mkGeoserverExtension {
    name = "wmts-multi-dimensional";
    version = "2.25.2"; # wmts-multi-dimensional
    hash = "sha256-J+buneos9vdfA8t9NS0IKo57ItorBN1IOmJvNHO/Qy0="; # wmts-multi-dimensional
  };

  wps = mkGeoserverExtension {
    name = "wps";
    version = "2.25.2"; # wps
    hash = "sha256-EqMx1aI/GR0nFvEMmo6RLXBZu8jJe+u2v+Muzf+ye9Q="; # wps
  };

  # Needs hazelcast (https://github.com/hazelcast/hazelcast (?)) which is not
  # available in nixpgs as of 2024/01.
  #wps-cluster-hazelcast = mkGeoserverExtension {
  #  name = "wps-cluster-hazelcast";
  #  version = "2.25.2"; # wps-cluster-hazelcast
  #  hash = "sha256-58BmwzdX3jGJHqvAjZjhIE5LxcLRZaUaeHmPrnN1PP8="; # wps-cluster-hazelcast
  #};

  wps-download = mkGeoserverExtension {
    name = "wps-download";
    version = "2.25.2"; # wps-download
    hash = "sha256-qcqw875SIzsjXMJFMwIm9et6Vo0G0qg6zrZlgml8Ql8="; # wps-download
  };

  # Needs Postrgres configuration or similar.
  # See https://docs.geoserver.org/main/en/user/extensions/wps-jdbc/index.html
  wps-jdbc = mkGeoserverExtension {
    name = "wps-jdbc";
    version = "2.25.2"; # wps-jdbc
    hash = "sha256-MsR5/yeDbBgValx4gm9v8JNdFQnGBTdwy5nkOyUXTAs="; # wps-jdbc
  };

  ysld = mkGeoserverExtension {
    name = "ysld";
    version = "2.25.2"; # ysld
    hash = "sha256-H8BfsRk6zk0kX94YY9yU8FeebTzjA8zagnVWU7Sr9/Q="; # ysld
  };

}
