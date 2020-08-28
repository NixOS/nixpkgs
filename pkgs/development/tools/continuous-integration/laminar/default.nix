{ stdenv
, lib
, fetchurl
, cmake
, capnproto
, sqlite
, boost
, zlib
, rapidjson
, pandoc
, enableSystemd ? false
, customConfig ? null
}:
let
  js.vue = fetchurl {
    url = "https://cdnjs.cloudflare.com/ajax/libs/vue/2.3.4/vue.min.js";
    sha256 = "01zklp5cyik65dfn64m8h2y2dxzgbyzgmbf99y7fwgnf0155r7pq";
  };
  js.vue-router = fetchurl {
    url =
      "https://cdnjs.cloudflare.com/ajax/libs/vue-router/2.7.0/vue-router.min.js";
    sha256 = "07gx7znb30rk1z7w6ca7dlfjp44q12bbq6jghwfm27mf6psa80as";
  };
  js.ansi_up = fetchurl {
    url = "https://raw.githubusercontent.com/drudru/ansi_up/v1.3.0/ansi_up.js";
    sha256 = "1993dywxqi2ylnxybwk7m0s0bg2bq7kfllpyr0s8ck6chd0p8i6r";
  };
  js.Chart = fetchurl {
    url = "https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.min.js";
    sha256 = "1jh4h12qchsba03dx03mrvs4r8g9qfjn56xm56jqzgqf7r209xq9";
  };
  css.bootstrap = fetchurl {
    url =
      "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css";
    sha256 = "11vx860prsx7wsy8b0yrrk04ih8kvrxkk8l16snsc4n286bdkyri";
  };
in stdenv.mkDerivation rec {
  name = "laminar";
  version = "0.8";
  src = fetchurl {
    url = "https://github.com/ohwgiles/laminar/archive/${version}.tar.gz";
    sha256 = "05g73j3vpib47kr7mackcazf7s6bc3xwz4h6k7sp7yb5ng7gj20g";
  };
  patches = [ ./patches/no-network.patch ];
  nativeBuildInputs = [ cmake pandoc ];
  buildInputs = [ capnproto sqlite boost zlib rapidjson ];
  preBuild = ''
    mkdir -p js css
    cp  ${js.vue}         js/vue.min.js
    cp  ${js.vue-router}  js/vue-router.min.js
    cp  ${js.ansi_up}     js/ansi_up.js
    cp  ${js.Chart}       js/Chart.min.js
    cp  ${css.bootstrap}  css/bootstrap.min.css
  '';
  postInstall = ''
    mv $out/usr/share $out
    mkdir $out/bin
    mv $out/usr/{bin,sbin}/* $out/bin
    rmdir $out/usr/{bin,sbin}
    rmdir $out/usr

    mkdir -p $out/share/doc/laminar
    pandoc -s ../UserManual.md -o $out/share/doc/laminar/UserManual.html
  '' + lib.optionalString (customConfig != null) ''
    cp ${customConfig} /etc/etc/laminar.conf
  '' + (if enableSystemd then ''
    sed -i "s,/etc/,$out/etc/," $out/lib/systemd/system/laminar.service
    sed -i "s,/usr/sbin/,$out/bin/," $out/lib/systemd/system/laminar.service
  '' else ''
    rm -r $out/lib # it contains only systemd unit file
  '');

  meta = with stdenv.lib; {
    description = "Lightweight and modular continuous integration service";
    homepage = "https://laminar.ohwg.net";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kaction ];
  };
}
