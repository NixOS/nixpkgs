{ stdenv, fetchurl }:

let
  packages = [
    # Kernel 2.6.29+
    { name = "5150-ucode-8.24.2.2"; sha256 = "1y8cah9xa8a9c7alh220cvmncjmwnacdz0kwsvg9lqr4cvzyclyj"; }

    # Kernel 2.6.30+
    { name = "6000-ucode-9.221.4.1"; sha256 = "0sw3v9807agx4mxdrfgsw7f195gs1f4zscnzcgpc8gb664r6413z"; }

    # Kernel 2.6.37+
    { name = "6050-ucode-41.28.5.1"; sha256 = "1i10rfn3kc07s2iqz79wvsrblhm360yz6v231dcz8sabvcyrlzar"; }
    { name = "100-ucode-39.31.5.1"; sha256 = "1jvzdaiklnw613c4drkjkcdlnnk6c9kk7f0jqdxfkgppydwssnc2"; }

    # Kernel 2.6.38+
    { name = "5000-ucode-8.83.5.1-1"; sha256 = "0pkzr4gflp3j0jm4rw66jypk3xn4bvpgdsnxjqwanyd64aj6naxg"; }

    # Kernel 3.2+
    { name = "6000g2b-ucode-18.168.6.1"; sha256 = "1shby6s9h4kfwmvg89505p61yq88ml1qccvw8h2m4l63a9mwg0qn"; }
    { name = "6000g2a-ucode-18.168.6.1"; sha256 = "1sdv4lkpfd87c95zbk8wgn0b4l4nbwkb0b4iwvrzpnmdarbn3wm7"; }
    { name = "1000-ucode-39.31.5.1"; sha256 = "0w69hfpwx79cph0517a6mkhsk51li2l0yhfr1jddmj3i4ny1y3zd"; }
    { name = "135-ucode-18.168.6.1"; sha256 = "1dvyzwkyzsmvlp13z84g2lzkr0w0p8mj7c98fwh3pwv0cmglf04c"; }
    { name = "105-ucode-18.168.6.1"; sha256 = "11z67ippn4hlmsnyv1lxknysrl3m5v908i9wf1nkm7kxw76biz04"; }
    { name = "2000-ucode-18.168.6.1"; sha256 = "0ax98hlmz11hqi0k81j5cizp2hwaah7j6s3hw7jdfsmwpzy9lwrm"; }
    { name = "2030-ucode-18.168.6.1"; sha256 = "0b69jpb46fk63ybyyb8lbh99j1d29ayp8fl98l18iqy3q7mx4ry8"; }

    # Kernel 3.10+
    { name = "7260-ucode-22.1.7.0"; sha256 = "0m31p98zwr70k3b9akha0d8n7x9ym43yg992jk8zd94159g37k0y"; }
    { name = "3160-ucode-22.1.7.0"; sha256 = "0qfm854xv6dc6kqj0vym1avrirrshnxp9yqnlx356zvfnqyx4l33"; }

    # Kernel 3.13+
    { name = "7260-ucode-22.24.8.0"; sha256 = "1zvw5dj3kv7rdnypcmp6na8mlfw735nzahy8qz35zrmda8b6gvqi"; }
    { name = "3160-ucode-22.24.8.0"; sha256 = "1jv3bhds3a3y2r719fqpc5cwb674hm3lwq9df11i6473f0xjs224"; }
    { name = "7265-ucode-22.24.8.0"; sha256 = "1pvmc58gyr62akzdj8gx02y3i3d67zwawm8zdvpg2q615721wjp9"; }

    # Kernel 3.14.9+
    { name = "7260-ucode-25.228.9.0"; sha256 = "0ppx9lpkc2l9aggdadw4y2cpdz5zqyckshzhlb1qj60jbajiny36"; }
    { name = "3160-ucode-25.228.9.0"; sha256 = "125kh5p21bx808l2al8v9a1g63396d1a1chf4amqa9zrp2aajmk8"; }
    { name = "7265-ucode-25.228.9.0"; sha256 = "1dv9bai1s6vdigsahbrxjwlndnp2dsgkqz8j7021d34s99kbi6z8"; }

    # Kernel 3.17+
    { name = "7260-ucode-23.11.10.0"; sha256 = "1d9w7kd3h3632qmwb44943lxdafjn3ii8ha9wdvqri3b8fjfn7sa"; }
    { name = "3160-ucode-23.11.10.0"; sha256 = "0ijpgfzz8735rsbkc6mvk3w7f1v9rr9dgy1l79vzmzc1vh2zpbdm"; }
    { name = "7265-ucode-23.11.10.0"; sha256 = "1az8nq6z1ns1220309wp8jq1sc5flz2ac5k41pgj50503h54rlvi"; }
  ];

  fetchPackage =
    { name, sha256 }: fetchurl {
      name = "iwlwifi-${name}.tgz";
      url = "http://wireless.kernel.org/en/users/Drivers/iwlwifi?action=AttachFile&do=get&target=iwlwifi-${name}.tgz";
      inherit sha256;
    };

  srcs = map fetchPackage packages;

in stdenv.mkDerivation {
  name = "iwlwifi";
  inherit srcs;

  unpackPhase = ''
    mkdir -p ./firmware
  '';

  buildPhase = ''
    for src in $srcs; do
      tar zxf $src
    done
  '';

  installPhase = ''
    mkdir -p $out/lib/firmware
    cp -r iwlwifi-*/*.ucode "$out/lib/firmware/"
  '';

  meta = {
    description = "Binary firmware collection from intel";
    homepage = http://wireless.kernel.org/en/users/Drivers/iwlwifi;
    license = stdenv.lib.licenses.unfreeRedistributableFirmware;
    platforms = stdenv.lib.platforms.linux;
  };
}
