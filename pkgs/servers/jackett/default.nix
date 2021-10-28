{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, krb5
, liburcu
, lttng-ust
, zlib
, openssl
, makeWrapper
}:

let
  liburcu-0-12 = liburcu.overrideAttrs (oldAttrs: rec {
    version = "0.12.2";
    src = fetchurl {
      url = "https://lttng.org/files/urcu/userspace-rcu-${version}.tar.bz2";
      sha256 = "0yx69kbx9zd6ayjzvwvglilhdnirq4f1x1sdv33jy8bc9wgc3vsf";
    };
  });

  lttng-ust-2-10 = (lttng-ust.override {
    liburcu = liburcu-0-12;
  }).overrideAttrs (oldAttrs: rec {
    version = "2.10.5";
    src = fetchurl {
      url = "https://lttng.org/files/lttng-ust/lttng-ust-${version}.tar.bz2";
      sha256 = "0ddwk0nl28bkv2xb78gz16a2bvlpfbjmzwfbgwf5p1cq46dyvy86";
    };
  });
in
stdenv.mkDerivation rec {
  pname = "jackett";
  version = "0.19.84";

  src =
    if stdenv.isAarch32 then
      fetchurl
        {
          url = "https://github.com/Jackett/Jackett/releases/download/v${version}/Jackett.Binaries.LinuxARM32.tar.gz";
          sha256 = "1iqv8k437rlik83mq019aq157p8bhk8sp2k28lp7mga66vs6wkhb";
        }
    else if stdenv.isAarch64 then
      fetchurl
        {
          url = "https://github.com/Jackett/Jackett/releases/download/v${version}/Jackett.Binaries.LinuxARM64.tar.gz";
          sha256 = "1sxp8s09m4gx1xv0cdyxdz5fqg5ihbzrnq9qy54wp34p5v3jknjh";
        }
    else if stdenv.isDarwin then
      fetchurl
        {
          url = "https://github.com/Jackett/Jackett/releases/download/v${version}/Jackett.Binaries.macOS.tar.gz";
          sha256 = "1489pgp1y77crpnnm5mfwvz81400hm3cnv0fq753wfpmgm9g4d4q";
        }
    else
      fetchurl {
        url = "https://github.com/Jackett/Jackett/releases/download/v${version}/Jackett.Binaries.LinuxAMDx64.tar.gz";
        sha256 = "0dfxnkql7l6dpyqiwd9al8a0nr93s5avb7k7pj0mlq8q38lb8bfk";
      };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  buildInputs = [ stdenv.cc.cc.lib krb5 lttng-ust-2-10 zlib ];

  libssl = openssl.out;

  installPhase = ''
    mkdir -p $out/{bin,share/jackett}
    cp -r * $out/share/jackett
    makeWrapper $out/share/jackett/jackett $out/bin/jackett \
      --set DOTNET_SYSTEM_GLOBALIZATION_INVARIANT 1 \
      --set LD_LIBRARY_PATH LD_LIBRARY_PATH:$libssl/lib
  '';

  meta = with lib; {
    description = "API Support for your favorite torrent trackers";
    homepage = "https://github.com/Jackett/Jackett/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ edwtjo nyanloutre purcell flexagoon ];
    platforms = with platforms; [ "x86_64-linux" "aarch64-linux" "armv7a-linux" "armv7l-linux" "x86_64-darwin" ];
  };
}
