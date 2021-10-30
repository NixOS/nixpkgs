{ callPackage
, cudatoolkit_10_1, cudatoolkit_10_2
, cudatoolkit_11_0, cudatoolkit_11_1, cudatoolkit_11_2, cudatoolkit_11_3, cudatoolkit_11_4
, cutensor_cudatoolkit_10_1, cutensor_cudatoolkit_10_2
, cutensor_cudatoolkit_11_0, cutensor_cudatoolkit_11_1, cutensor_cudatoolkit_11_2, cutensor_cudatoolkit_11_3, cutensor_cudatoolkit_11_4
}:

rec {

  cuda-library-samples_cudatoolkit_10_1 = callPackage ./generic.nix {
    cudatoolkit = cudatoolkit_10_1;
    cutensor_cudatoolkit = cutensor_cudatoolkit_10_1;
  };

  cuda-library-samples_cudatoolkit_10_2 = callPackage ./generic.nix {
    cudatoolkit = cudatoolkit_10_2;
    cutensor_cudatoolkit = cutensor_cudatoolkit_10_2;
  };

  cuda-library-samples_cudatoolkit_10 =
    cuda-library-samples_cudatoolkit_10_2;

  ##

  cuda-library-samples_cudatoolkit_11_0 = callPackage ./generic.nix {
    cudatoolkit = cudatoolkit_11_0;
    cutensor_cudatoolkit = cutensor_cudatoolkit_11_0;
  };

  cuda-library-samples_cudatoolkit_11_1 = callPackage ./generic.nix {
    cudatoolkit = cudatoolkit_11_1;
    cutensor_cudatoolkit = cutensor_cudatoolkit_11_1;
  };

  cuda-library-samples_cudatoolkit_11_2 = callPackage ./generic.nix {
    cudatoolkit = cudatoolkit_11_2;
    cutensor_cudatoolkit = cutensor_cudatoolkit_11_2;
  };

  cuda-library-samples_cudatoolkit_11_3 = callPackage ./generic.nix {
    cudatoolkit = cudatoolkit_11_3;
    cutensor_cudatoolkit = cutensor_cudatoolkit_11_3;
  };

  cuda-library-samples_cudatoolkit_11_4 = callPackage ./generic.nix {
    cudatoolkit = cudatoolkit_11_4;
    cutensor_cudatoolkit = cutensor_cudatoolkit_11_4;
  };

  cuda-library-samples_cudatoolkit_11 =
    cuda-library-samples_cudatoolkit_11_4;
}
