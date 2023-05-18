{ fetchurl }:

{
  mxu11x0_4 = {
    version = "4.1";
    src = fetchurl {
      url = "https://www.moxa.com/getmedia/b152d8c2-b9d6-4bc7-b0f4-420633b4bc2d/moxa-uport-1100-series-linux-kernel-4.x-driver-v4.1.tgz";
      sha256 = "sha256-cM3imuMG483ZinFazVa8V4Id0kUGlHaezDHnYtSSb28=";
    };
  };
  mxu11x0_5 = {
    version = "5.1";
    src = fetchurl {
      url = "https://www.moxa.com/getmedia/57dfa4c1-8a2a-4da6-84c1-a36944ead74d/moxa-uport-1100-series-linux-kernel-5.x-driver-v5.1.tgz";
      sha256 = "sha256-P1YMlyAhS955CSBiZ/tyu5m6ds2PiFMcHmyrdTjloPs=";
    };
  };
}
