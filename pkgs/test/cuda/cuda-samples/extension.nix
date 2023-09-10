final: prev: let

  sha256 = {
    "10.0" = "1zvh4xsdyc59m87brpcmssxsjlp9dkynh4asnkcmc3g94f53l0jw";
    "10.1" = "1s8ka0hznrni36ajhzf2gqpdrl8kd8fi047qijxks5l2abc093qd";
    "10.2" = "01p1innzgh9siacpld6nsqimj8jkg93rk4gj8q4crn62pa5vhd94";
    "11.0" = "1n3vjc8c7zdig2xgl5fppavrphqzhdiv9m9nk6smh4f99fwi0705";
    "11.1" = "1kjixk50i8y1bkiwbdn5lkv342crvkmbvy1xl5j3lsa1ica21kwh";
    "11.2" = "1p1qjvfbm28l933mmnln02rqrf0cy9kbpsyb488d1haiqzvrazl1";
    "11.3" = "0kbibb6pgz8j5iq6284axcnmycaha9bw8qlmdp6yfwmnahq1v0yz";
    "11.4" = "082dkk5y34wyvjgj2p5j1d00rk8xaxb9z0mhvz16bd469r1bw2qk";
    "11.5" = "sha256-AKRZbke0K59lakhTi8dX2cR2aBuWPZkiQxyKaZTvHrI=";
    "11.6" = "sha256-AsLNmAplfuQbXg9zt09tXAuFJ524EtTYsQuUlV1tPkE=";
    "11.7" = throw "The tag 11.7 of cuda-samples does not exist";
    "11.8" = "sha256-7+1P8+wqTKUGbCUBXGMDO9PkxYr2+PLDx9W2hXtXbuc=";
    "12.0" = "sha256-Lj2kbdVFrJo5xPYPMiE4BS7Z8gpU5JLKXVJhZABUe/g=";
  }.${prev.cudaVersion};

in {
  cuda-samples = final.callPackage ./generic.nix {
    inherit sha256;
  };
}
