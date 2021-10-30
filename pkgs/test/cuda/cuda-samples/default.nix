{ callPackage
, cudatoolkit_10_0, cudatoolkit_10_1, cudatoolkit_10_2
, cudatoolkit_11_0, cudatoolkit_11_1, cudatoolkit_11_2, cudatoolkit_11_3, cudatoolkit_11_4
}:

rec {
  ##

  cuda-samples_cudatoolkit_10_0 = callPackage ./generic.nix {
    cudatoolkit = cudatoolkit_10_0;
    sha256 = "1zvh4xsdyc59m87brpcmssxsjlp9dkynh4asnkcmc3g94f53l0jw";
  };

  cuda-samples_cudatoolkit_10_1 = callPackage ./generic.nix {
    cudatoolkit = cudatoolkit_10_1;
    sha256 = "1s8ka0hznrni36ajhzf2gqpdrl8kd8fi047qijxks5l2abc093qd";
  };

  cuda-samples_cudatoolkit_10_2 = callPackage ./generic.nix {
    cudatoolkit = cudatoolkit_10_2;
    sha256 = "01p1innzgh9siacpld6nsqimj8jkg93rk4gj8q4crn62pa5vhd94";
  };

  cuda-samples_cudatoolkit_10 = cuda-samples_cudatoolkit_10_2;

  ##

  cuda-samples_cudatoolkit_11_0 = callPackage ./generic.nix {
    cudatoolkit = cudatoolkit_11_0;
    sha256 = "1n3vjc8c7zdig2xgl5fppavrphqzhdiv9m9nk6smh4f99fwi0705";
  };

  cuda-samples_cudatoolkit_11_1 = callPackage ./generic.nix {
    cudatoolkit = cudatoolkit_11_1;
    sha256 = "1kjixk50i8y1bkiwbdn5lkv342crvkmbvy1xl5j3lsa1ica21kwh";
  };

  cuda-samples_cudatoolkit_11_2 = callPackage ./generic.nix {
    cudatoolkit = cudatoolkit_11_2;
    sha256 = "1p1qjvfbm28l933mmnln02rqrf0cy9kbpsyb488d1haiqzvrazl1";
  };

  cuda-samples_cudatoolkit_11_3 = callPackage ./generic.nix {
    cudatoolkit = cudatoolkit_11_3;
    sha256 = "0kbibb6pgz8j5iq6284axcnmycaha9bw8qlmdp6yfwmnahq1v0yz";
  };

  cuda-samples_cudatoolkit_11_4 = callPackage ./generic.nix {
    cudatoolkit = cudatoolkit_11_4;
    sha256 = "082dkk5y34wyvjgj2p5j1d00rk8xaxb9z0mhvz16bd469r1bw2qk";
  };

  cuda-samples_cudatoolkit_11 = cuda-samples_cudatoolkit_11_4;
}
