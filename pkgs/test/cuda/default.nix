{ callPackage }:

rec {
  cuda-samplesPackages = callPackage ./cuda-samples { };
  inherit (cuda-samplesPackages)
    cuda-samples_cudatoolkit_10
    cuda-samples_cudatoolkit_10_0
    cuda-samples_cudatoolkit_10_1
    cuda-samples_cudatoolkit_10_2
    cuda-samples_cudatoolkit_11
    cuda-samples_cudatoolkit_11_0
    cuda-samples_cudatoolkit_11_1
    cuda-samples_cudatoolkit_11_2;

  cuda-library-samplesPackages = callPackage ./cuda-library-samples { };
  inherit (cuda-library-samplesPackages)
    cuda-library-samples_cudatoolkit_10
    cuda-library-samples_cudatoolkit_10_1
    cuda-library-samples_cudatoolkit_10_2
    cuda-library-samples_cudatoolkit_11
    cuda-library-samples_cudatoolkit_11_0
    cuda-library-samples_cudatoolkit_11_1
    cuda-library-samples_cudatoolkit_11_2;
}
