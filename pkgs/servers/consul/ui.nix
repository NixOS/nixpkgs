{ stdenv, fetchzip }:

let
  version = "0.3.0";
  meta = with stdenv.lib; {
    homepage = http://www.consul.io/intro/getting-started/ui.html;
    description = "The static files for Consul's UI (used via -ui-dir)";
    maintainers = with maintainers; [ cstrahan ];
    license = licenses.mpl20 ;
    platforms = platforms.all;
  };
in (fetchzip {
  name = "consul-ui-${version}";
  url = "https://dl.bintray.com/mitchellh/consul/${version}_web_ui.zip";
  sha256 = "0p4mhlrqidd6p3899wd3i9p41bdbb5avbz5986mnxg9f7dvhjdrc";
}) // { inherit meta; }

