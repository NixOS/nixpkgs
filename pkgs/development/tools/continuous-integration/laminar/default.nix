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
}:
let
  js.vue = fetchurl {
    url = "https://cdnjs.cloudflare.com/ajax/libs/vue/2.6.12/vue.min.js";
    sha256 = "1hm5kci2g6n5ikrvp1kpkkdzimjgylv1xicg2vnkbvd9rb56qa99";
  };
  js.vue-router = fetchurl {
    url =
      "https://cdnjs.cloudflare.com/ajax/libs/vue-router/3.4.8/vue-router.min.js";
    sha256 = "0418waib896ywwxkxliip75zp94k3s9wld51afrqrcq70axld0c9";
  };
  js.ansi_up = fetchurl {
    url = "https://raw.githubusercontent.com/drudru/ansi_up/v1.3.0/ansi_up.js";
    sha256 = "1993dywxqi2ylnxybwk7m0s0bg2bq7kfllpyr0s8ck6chd0p8i6r";
  };
  js.Chart = fetchurl {
    url = "https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.7.2/Chart.min.js";
    sha256 = "1jh4h12qchsba03dx03mrvs4r8g9qfjn56xm56jqzgqf7r209xq9";
  };
in stdenv.mkDerivation rec {
  pname = "laminar";
  version = "1.0";
  src = fetchurl {
    url = "https://github.com/ohwgiles/laminar/archive/${version}.tar.gz";
    sha256 = "11m6h3rdmj2rsmsryy7r40gqccj4gg1cnqwy6blscs87gx4s423g";
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
  '';

  postInstall = ''
    mv $out/usr/share/* $out/share/
    rmdir $out/usr/share $out/usr

    mkdir -p $out/share/doc/laminar
    pandoc -s ../UserManual.md -o $out/share/doc/laminar/UserManual.html
    rm -rf $out/lib # remove upstream systemd units
    rm -rf $out/etc # remove upstream config file
  '';

  meta = with lib; {
    description = "Lightweight and modular continuous integration service";
    homepage = "https://laminar.ohwg.net";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ kaction maralorn ];
  };
}
