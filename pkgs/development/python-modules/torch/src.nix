{
  version,
  fetchFromGitLab,
  fetchFromGitHub,
  runCommand,
}:
assert version == "2.5.1";
(rec {
  src_DCGM = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "DCGM";
    rev = "ffde4e54bc7249a6039a5e6b45b395141e1217f9";
    hash = "sha256-jlnq25byEep7wRF3luOIGaiaYjqSVaTBx02N6gE/ox8=";
  };
  src_FP16 = fetchFromGitHub {
    owner = "Maratyszcza";
    repo = "FP16";
    rev = "4dfe081cf6bcd15db339cf2680b9281b8451eeb3";
    hash = "sha256-B27LtVnL52niaFgPW0pp5Uulub/Q3NvtSDkJNahrSBk=";
  };
  src_FXdiv = fetchFromGitHub {
    owner = "Maratyszcza";
    repo = "FXdiv";
    rev = "b408327ac2a15ec3e43352421954f5b1967701d1";
    hash = "sha256-BEjscsejYVhRxDAmah5DT3+bglp8G5wUTTYL7+HjWds=";
  };
  src_GSL = fetchFromGitHub {
    owner = "microsoft";
    repo = "GSL";
    rev = "6f4529395c5b7c2d661812257cd6780c67e54afa";
    hash = "sha256-sNTDH1ohz+rcnBvA5KkarHKdRMQPW0c2LeSVPdEYx6Q=";
  };
  src_NNPACK = fetchFromGitHub {
    owner = "Maratyszcza";
    repo = "NNPACK";
    rev = "c07e3a0400713d546e0dea2d5466dd22ea389c73";
    hash = "sha256-GzF53u1ELtmEH3WbBzGBemlQhjj3EIKB+37wMtSYE2g=";
  };
  src_NVTX = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "NVTX";
    rev = "e170594ac7cf1dac584da473d4ca9301087090c1";
    hash = "sha256-n34BPxRnAW301ba1lXqSlGh7jaPqNjpp45GnJ+yDapI=";
  };
  src_PeachPy = fetchFromGitHub {
    owner = "malfet";
    repo = "PeachPy";
    rev = "f45429b087dd7d5bc78bb40dc7cf06425c252d67";
    hash = "sha256-eyhfnOOZPtsJwjkF6ybv3F77fyjaV6wzgu+LxadZVw0=";
  };
  src_VulkanMemoryAllocator = fetchFromGitHub {
    owner = "GPUOpen-LibrariesAndSDKs";
    repo = "VulkanMemoryAllocator";
    rev = "a6bfc237255a6bac1513f7c1ebde6d8aed6b5191";
    hash = "sha256-urUebQaPTgCECmm4Espri1HqYGy0ueAqTBu/VSiX/8I=";
  };
  src_XNNPACK = fetchFromGitHub {
    owner = "google";
    repo = "XNNPACK";
    rev = "fcbf55af6cf28a4627bcd1f703ab7ad843f0f3a2";
    hash = "sha256-lnycZPoswZQwRWJjR4if4qp8O9KhgYNbtwjNuoem48w=";
  };
  src_asmjit = fetchFromGitHub {
    owner = "asmjit";
    repo = "asmjit";
    rev = "d3fbf7c9bc7c1d1365a94a45614b91c5a3706b81";
    hash = "sha256-0Wv9dxrh9GfajTFb+NpguqqSWH0mqJAj03bxFVJbft8=";
  };
  src_benchmark = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
    rev = "0d98dba29d66e93259db7daa53a9327df767a415";
    hash = "sha256-yUiFxi80FWBmTZgqmqTMf9oqcBeg3o4I4vKd4djyRWY=";
  };
  src_benchmark_onnx = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
    rev = "2dd015dfef425c866d9a43f2c67d8b52d709acb6";
    hash = "sha256-pUW9YVaujs/y00/SiPqDgK4wvVsaM7QUp/65k0t7Yr0=";
  };
  src_benchmark_opentelemetry-cpp = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
    rev = "d572f4777349d43653b21d6c2fc63020ab326db2";
    hash = "sha256-gg3g/0Ki29FnGqKv9lDTs5oA9NjH23qQ+hTdVtSU+zo=";
  };
  src_benchmark_protobuf = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
    rev = "5b7683f49e1e9223cf9927b24f6fd3d6bd82e3f8";
    hash = "sha256-iFRgjLkftuszAqBnmS9GXU8BwYnabmwMAQyw19sfjb4=";
  };
  src_civetweb = fetchFromGitHub {
    owner = "civetweb";
    repo = "civetweb";
    rev = "eefb26f82b233268fc98577d265352720d477ba4";
    hash = "sha256-Qh6BGPk7a01YzCeX42+Og9M+fjXRs7kzNUCyT4mYab4=";
  };
  src_clang-cindex-python3 = fetchFromGitHub {
    owner = "wjakob";
    repo = "clang-cindex-python3";
    rev = "6a00cbc4a9b8e68b71caf7f774b3f9c753ae84d5";
    hash = "sha256-IDUIuAvgCzWaHoTJUZrH15bqoVcP8bZk+Gs1Ae6/CpY=";
  };
  src_cpp-httplib = fetchFromGitHub {
    owner = "yhirose";
    repo = "cpp-httplib";
    rev = "3b6597bba913d51161383657829b7e644e59c006";
    hash = "sha256-dd9NckF1mGhQOyV1LO07QyP51l1kSpYQOH0GkG4v2eE=";
  };
  src_cpr = fetchFromGitHub {
    owner = "libcpr";
    repo = "cpr";
    rev = "871ed52d350214a034f6ef8a3b8f51c5ce1bd400";
    hash = "sha256-TxoDCIa7pS+nfI8hNiGIRQKpYNrKSd1yCXPfVXPcRW8=";
  };
  src_cpuinfo = fetchFromGitHub {
    owner = "pytorch";
    repo = "cpuinfo";
    rev = "094fc30b9256f54dad5ad23bcbfb5de74781422f";
    hash = "sha256-JbIEQ6jFprbMpeH8IBhuRo3VXxo8a32lmT4yfxSIEj0=";
  };
  src_cpuinfo_fbgemm = fetchFromGitHub {
    owner = "pytorch";
    repo = "cpuinfo";
    rev = "ed8b86a253800bafdb7b25c5c399f91bff9cb1f3";
    hash = "sha256-YRqBU83AjxbSE5zquhi4iIiJna/qFWA0jo2GBifqzi8=";
  };
  src_cudnn-frontend = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cudnn-frontend";
    rev = "2533f5e5c1877fd76266133c1479ef1643ce3a8b";
    hash = "sha256-z9HH/ZEPv+Nf0eB0npjJiakjXx6cwoesKKnYNS1r9TE=";
  };
  src_cutlass = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cutlass";
    rev = "bbe579a9e3beb6ea6626d9227ec32d0dae119a49";
    hash = "sha256-81O80F3MMOn22N9UaXLU6/9DTVWenYvKhLTHoxw8EEU=";
  };
  src_cutlass_fbgemm = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cutlass";
    rev = "fc9ebc645b63f3a6bc80aaefde5c063fb72110d6";
    hash = "sha256-e2SwXNNwjl/1fV64b+mOJvwGDYeO1LFcqZGbNten37U=";
  };
  src_dynolog = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "dynolog";
    rev = "7d04a0053a845370ae06ce317a22a48e9edcc74e";
    hash = "sha256-Je6wAz+uJ/AiAnSZVQ4+pGajZ8DymS0qI9ekB8fGYOo=";
  };
  src_eigen = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "libeigen";
    repo = "eigen";
    rev = "3147391d946bb4b6c68edd901f2add6ac1f31f8c";
    hash = "sha256-1/4xMetKMDOgZgzz3WMxfHUEpmdAm52RqZvz6i0mLEw=";
  };
  src_fbgemm = fetchFromGitHub {
    owner = "pytorch";
    repo = "fbgemm";
    rev = "dbc3157bf256f1339b3fa1fef2be89ac4078be0e";
    hash = "sha256-PJiFtLnPA6IgxZ2sXIcyyjFRGtb+sG5y2hiWEwFuBOU=";
  };
  src_fbjni = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "fbjni";
    rev = "7e1e1fe3858c63c251c637ae41a20de425dde96f";
    hash = "sha256-PsgUHtCE3dNR2QdUnRjrXb0ZKZNGwFkA8RWYkZEklEY=";
  };
  src_flatbuffers = fetchFromGitHub {
    owner = "google";
    repo = "flatbuffers";
    rev = "01834de25e4bf3975a9a00e816292b1ad0fe184b";
    hash = "sha256-h0lF7jf1cDVVyqhUCi7D0NoZ3b4X/vWXsFplND80lGs=";
  };
  src_fmt = fetchFromGitHub {
    owner = "fmtlib";
    repo = "fmt";
    rev = "0c9fce2ffefecfdce794e1859584e25877b7b592";
    hash = "sha256-IKNt4xUoVi750zBti5iJJcCk3zivTt7nU12RIf8pM+0=";
  };
  src_fmt_dynolog = fetchFromGitHub {
    owner = "fmtlib";
    repo = "fmt";
    rev = "cd4af11efc9c622896a3e4cb599fa28668ca3d05";
    hash = "sha256-Ks3UG3V0Pz6qkKYFhy71ZYlZ9CPijO6GBrfMqX5zAp8=";
  };
  src_fmt_kineto = fetchFromGitHub {
    owner = "fmtlib";
    repo = "fmt";
    rev = "0041a40c1350ba702d475b9c4ad62da77caea164";
    hash = "sha256-PtzSB2mekUT7bjhXC/+F5UpSUvcdIkXTWnIz+jkAUuU=";
  };
  src_gemmlowp = fetchFromGitHub {
    owner = "google";
    repo = "gemmlowp";
    rev = "3fb5c176c17c765a3492cd2f0321b0dab712f350";
    hash = "sha256-G3PAf9j7Tb4dUoaV9Tmxkkfu3v+w0uFbZ+MWS68tlRw=";
  };
  src_gflags = fetchFromGitHub {
    owner = "gflags";
    repo = "gflags";
    rev = "e171aa2d15ed9eb17054558e0b3a6a413bb01067";
    hash = "sha256-4NLd/p72H7ZiFCCVjTfM/rDvZ8CVPMxYpnJ2O1od8ZA=";
  };
  src_gflags_gflags = fetchFromGitHub {
    owner = "gflags";
    repo = "gflags";
    rev = "8411df715cf522606e3b1aca386ddfc0b63d34b4";
    hash = "sha256-Bb4g64u5a0QRWwDl1ryNXmht6NKFWPW9bAF07yYRJ6I=";
  };
  src_glog = fetchFromGitHub {
    owner = "google";
    repo = "glog";
    rev = "b33e3bad4c46c8a6345525fd822af355e5ef9446";
    hash = "sha256-xqRp9vaauBkKz2CXbh/Z4TWqhaUtqfbsSlbYZR/kW9s=";
  };
  src_gloo = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "gloo";
    rev = "5354032ea08eadd7fc4456477f7f7c6308818509";
    hash = "sha256-JMLtxyQz7jechJ5DmMq0guOfL9leI6khdI9g/5Ckgfc=";
  };
  src_googletest = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "e2239ee6043f73722e7aa812a459f54a28552929";
    hash = "sha256-SjlJxushfry13RGA7BCjYC9oZqV4z6x8dOiHfl/wpF0=";
  };
  src_googletest_dynolog = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "58d77fa8070e8cec2dc1ed015d66b454c8d78850";
    hash = "sha256-W+OxRTVtemt2esw4P7IyGWXOonUN5ZuscjvzqkYvZbM=";
  };
  src_googletest_fbgemm = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "cbf019de22c8dd37b2108da35b2748fd702d1796";
    hash = "sha256-G6NihPly7czG2NOX66kFfcf5ya+XRrUWt4SP1Y9JPzs=";
  };
  src_googletest_kineto = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "7aca84427f224eeed3144123d5230d5871e93347";
    hash = "sha256-ML144v86Kb9KSyxpqn8+XdKeU8r53PiMyh2ZzNYDyZU=";
  };
  src_googletest_opentelemetry-cpp = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "b796f7d44681514f58a683a3a71ff17c94edb0c1";
    hash = "sha256-LVLEn+e7c8013pwiLzJiiIObyrlbBHYaioO/SWbItPQ=";
  };
  src_googletest_protobuf = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "5ec7f0c4a113e2f18ac2c6cc7df51ad6afc24081";
    hash = "sha256-Zh7t6kOabEZxIuTwREerNSgbZLPnGWv78h0wQQAIuT4=";
  };
  src_googletest_tensorpipe = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "aee0f9d9b5b87796ee8a0ab26b7587ec30e8858e";
    hash = "sha256-L2HR+QTQmagk92JiuW3TRx47so33xQvewdeYL1ipUPs=";
  };
  src_hipify_torch = fetchFromGitHub {
    owner = "ROCmSoftwarePlatform";
    repo = "hipify_torch";
    rev = "23f53b025b466d8ec3c45d52290d3442f7fbe6b1";
    hash = "sha256-ohbGKy0sxa5pQy9EwsZk2UWmjveCZaJu/PEK2MLbjII=";
  };
  src_ideep = fetchFromGitHub {
    owner = "intel";
    repo = "ideep";
    rev = "41d636c2bbcea6bff0faf97cdb65a48cdde987af";
    hash = "sha256-i4MK6zTScB0healwSoTNBP+UY2dHUfyyDUfBhDDSBCc=";
  };
  src_ittapi = fetchFromGitHub {
    owner = "intel";
    repo = "ittapi";
    rev = "5b8a7d7422611c3a0d799fb5fc5dd4abfae35b42";
    hash = "sha256-VxJky2TF3RcIMqjNaAK/mvpC0afkwpAsY0cD6Ergkls=";
  };
  src_json = fetchFromGitHub {
    owner = "nlohmann";
    repo = "json";
    rev = "87cda1d6646592ac5866dc703c8e1839046a6806";
    hash = "sha256-lXYJGWwLyQPqvxnDRWoDLXdjiD81r1eNHi7vRdbIuJ0=";
  };
  src_json_dynolog = fetchFromGitHub {
    owner = "nlohmann";
    repo = "json";
    rev = "4f8fba14066156b73f1189a2b8bd568bde5284c5";
    hash = "sha256-DTsZrdB9GcaNkx7ZKxcgCA3A9ShM5icSF0xyGguJNbk=";
  };
  src_json_opentelemetry-cpp = fetchFromGitHub {
    owner = "nlohmann";
    repo = "json";
    rev = "bc889afb4c5bf1c0d8ee29ef35eaaf4c8bef8a5d";
    hash = "sha256-SUdhIV7tjtacf5DkoWk9cnkfyMlrkg8ZU7XnPZd22Tw=";
  };
  src_kineto = fetchFromGitHub {
    owner = "pytorch";
    repo = "kineto";
    rev = "d9753139d181b9ff42872465aac0e5d3018be415";
    hash = "sha256-m1Uul9HKZLAiST7GQmvd9+9ziJSU+9Hjq8D24KiAyto=";
  };
  src_libnop = fetchFromGitHub {
    owner = "google";
    repo = "libnop";
    rev = "910b55815be16109f04f4180e9adee14fb4ce281";
    hash = "sha256-AsPZt+ylfdGpytQ1RoQljKeXE2uGkGONCaWzLK2sZhA=";
  };
  src_libuv = fetchFromGitHub {
    owner = "libuv";
    repo = "libuv";
    rev = "1dff88e5161cba5c59276d2070d2e304e4dcb242";
    hash = "sha256-i6AYD1Ony0L2+3yWK6bxOfwoZEvd9qCg33QSqA7bRXI=";
  };
  src_mimalloc = fetchFromGitHub {
    owner = "microsoft";
    repo = "mimalloc";
    rev = "b66e3214d8a104669c2ec05ae91ebc26a8f5ab78";
    hash = "sha256-uwuqln08Hx1d2l7GNn8/8hzOA1Pmzob5g17XgFb+blg=";
  };
  src_mkl-dnn = fetchFromGitHub {
    owner = "intel";
    repo = "mkl-dnn";
    rev = "66f0cb9eb66affd2da3bf5f8d897376f04aae6af";
    hash = "sha256-/ERkk6bgGEKoJEVdnBxMFEzB8pii71t3zQZNtyg+TdQ=";
  };
  src_nccl = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nccl";
    rev = "ab2b89c4c339bd7f816fbc114a4b05d386b66290";
    hash = "sha256-IF2tILwW8XnzSmfn7N1CO7jXL95gUp02guIW5n1eaig=";
  };
  src_onnx = fetchFromGitHub {
    owner = "onnx";
    repo = "onnx";
    rev = "3bf92c03a9f27eba3bda1e5b9e63ea20ec213557";
    hash = "sha256-JmxnsHRrzj2QzPz3Yndw0MmgZJ8MDYxHjuQ7PQkQsDg=";
  };
  src_opentelemetry-cpp = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-cpp";
    rev = "a799f4aed9c94b765dcdaabaeab7d5e7e2310878";
    hash = "sha256-jLRUpB9aDvxsc7B42b08vN2rygN/ycgOyt78i2Hms0Q=";
  };
  src_opentelemetry-proto = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "opentelemetry-proto";
    rev = "4ca4f0335c63cda7ab31ea7ed70d6553aee14dce";
    hash = "sha256-A14YrqvBAEBBPzvxcNVY2sJok+54/mHKNQPRaf9QLzs=";
  };
  src_opentracing-cpp = fetchFromGitHub {
    owner = "opentracing";
    repo = "opentracing-cpp";
    rev = "06b57f48ded1fa3bdd3d4346f6ef29e40e08eaf5";
    hash = "sha256-XlQi26ynXKDwA86DwsDw+hhKR8bcdnrtFH1CpAzVlLs=";
  };
  src_pfs = fetchFromGitHub {
    owner = "dtrugman";
    repo = "pfs";
    rev = "f68a2fa8ea36c783bdd760371411fcb495aa3150";
    hash = "sha256-VB7/7hi4vZKgpjpgir+CyWIMwoNLHGRIXPJvVOn8Pq4=";
  };
  src_pocketfft = fetchFromGitHub {
    owner = "mreineck";
    repo = "pocketfft";
    rev = "9d3ab05a7fffbc71a492bc6a17be034e83e8f0fe";
    hash = "sha256-RSbimayr8Np7YP0aUo1MNusFmhi9jjDfgGXbiISR+/8=";
  };
  src_prometheus-cpp = fetchFromGitHub {
    owner = "jupp0r";
    repo = "prometheus-cpp";
    rev = "c9ffcdda9086ffd9e1283ea7a0276d831f3c8a8d";
    hash = "sha256-qx6oBxd0YrUyFq+7ArnKBqOwrl5X8RS9nErhRDUJ7+8=";
  };
  src_protobuf = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "protobuf";
    rev = "d1eca4e4b421cd2997495c4b4e65cea6be4e9b8a";
    hash = "sha256-InCW/Sb4E7dQeg3VHgpCtm91qqfh0Qpmu4ZzKffacOQ=";
  };
  src_psimd = fetchFromGitHub {
    owner = "Maratyszcza";
    repo = "psimd";
    rev = "072586a71b55b7f8c584153d223e95687148a900";
    hash = "sha256-lV+VZi2b4SQlRYrhKx9Dxc6HlDEFz3newvcBjTekupo=";
  };
  src_pthreadpool = fetchFromGitHub {
    owner = "Maratyszcza";
    repo = "pthreadpool";
    rev = "4fe0e1e183925bf8cfa6aae24237e724a96479b8";
    hash = "sha256-R4YmNzWEELSkAws/ejmNVxqXDTJwcqjLU/o/HvgRn2E=";
  };
  src_pybind11 = fetchFromGitHub {
    owner = "pybind";
    repo = "pybind11";
    rev = "7c33cdc2d39c7b99a122579f53bc94c8eb3332ff";
    hash = "sha256-cpxhrTFihA+gWmX62a+EQF3lccUyvu+d1MU2IC/CN6Q=";
  };
  src_pybind11_onnx = fetchFromGitHub {
    owner = "pybind";
    repo = "pybind11";
    rev = "5b0a6fc2017fcc176545afe3e09c9f9885283242";
    hash = "sha256-n7nLEG2+sSR9wnxM+C8FWc2B+Mx74Pan1+IQf+h2bGU=";
  };
  src_pybind11_tensorpipe = fetchFromGitHub {
    owner = "pybind";
    repo = "pybind11";
    rev = "a23996fce38ff6ccfbcdc09f1e63f2c4be5ea2ef";
    hash = "sha256-3TALLHJAeWCSf88oBgLyyUoI/HyWGasAcAy4fGOQt04=";
  };
  src_pytorch = fetchFromGitHub {
    owner = "pytorch";
    repo = "pytorch";
    rev = "v2.5.1";
    hash = "sha256-GknW0DZAx2at+SwjKm2HrjCPuvaeXXm1PD7Vep/aTBQ=";
  };
  src_sleef = fetchFromGitHub {
    owner = "shibatch";
    repo = "sleef";
    rev = "60e76d2bce17d278b439d9da17177c8f957a9e9b";
    hash = "sha256-JfARLkdt4je8ll+oqPGJqzUCQbsXoJ0bbX3jf0aHd0o=";
  };
  src_tensorpipe = fetchFromGitHub {
    owner = "pytorch";
    repo = "tensorpipe";
    rev = "52791a2fd214b2a9dc5759d36725909c1daa7f2e";
    hash = "sha256-i+CtjNFPDUzFCPxP0//jMLJDrQoorg0On9NfoVaMUxI=";
  };
  src_vcpkg = fetchFromGitHub {
    owner = "Microsoft";
    repo = "vcpkg";
    rev = "8eb57355a4ffb410a2e94c07b4dca2dffbee8e50";
    hash = "sha256-u+4vyOphnowoaZgfkCbzF7Q4tuz2GN1bHylaKw352Lc=";
  };
  src_DCGM_recursive = src_DCGM;
  src_FP16_recursive = src_FP16;
  src_FXdiv_recursive = src_FXdiv;
  src_GSL_recursive = src_GSL;
  src_NNPACK_recursive = src_NNPACK;
  src_NVTX_recursive = src_NVTX;
  src_PeachPy_recursive = src_PeachPy;
  src_VulkanMemoryAllocator_recursive = src_VulkanMemoryAllocator;
  src_XNNPACK_recursive = src_XNNPACK;
  src_asmjit_recursive = src_asmjit;
  src_benchmark_recursive = src_benchmark;
  src_benchmark_onnx_recursive = src_benchmark_onnx;
  src_benchmark_opentelemetry-cpp_recursive = src_benchmark_opentelemetry-cpp;
  src_benchmark_protobuf_recursive = src_benchmark_protobuf;
  src_civetweb_recursive = src_civetweb;
  src_clang-cindex-python3_recursive = src_clang-cindex-python3;
  src_cpp-httplib_recursive = src_cpp-httplib;
  src_cpr_recursive = src_cpr;
  src_cpuinfo_recursive = src_cpuinfo;
  src_cpuinfo_fbgemm_recursive = src_cpuinfo_fbgemm;
  src_cudnn-frontend_recursive = src_cudnn-frontend;
  src_cutlass_recursive = src_cutlass;
  src_cutlass_fbgemm_recursive = src_cutlass_fbgemm;
  src_dynolog_recursive = runCommand "dynolog" { } ''
    cp -r ${src_dynolog} $out
    chmod u+w $out/third_party/DCGM
    cp -r ${src_DCGM_recursive}/* $out/third_party/DCGM
    chmod u+w $out/third_party/cpr
    cp -r ${src_cpr_recursive}/* $out/third_party/cpr
    chmod u+w $out/third_party/fmt
    cp -r ${src_fmt_dynolog_recursive}/* $out/third_party/fmt
    chmod u+w $out/third_party/gflags
    cp -r ${src_gflags_recursive}/* $out/third_party/gflags
    chmod u+w $out/third_party/glog
    cp -r ${src_glog_recursive}/* $out/third_party/glog
    chmod u+w $out/third_party/googletest
    cp -r ${src_googletest_dynolog_recursive}/* $out/third_party/googletest
    chmod u+w $out/third_party/json
    cp -r ${src_json_dynolog_recursive}/* $out/third_party/json
    chmod u+w $out/third_party/pfs
    cp -r ${src_pfs_recursive}/* $out/third_party/pfs
  '';
  src_eigen_recursive = src_eigen;
  src_fbgemm_recursive = runCommand "fbgemm" { } ''
    cp -r ${src_fbgemm} $out
    chmod u+w $out/third_party/asmjit
    cp -r ${src_asmjit_recursive}/* $out/third_party/asmjit
    chmod u+w $out/third_party/cpuinfo
    cp -r ${src_cpuinfo_fbgemm_recursive}/* $out/third_party/cpuinfo
    chmod u+w $out/third_party/cutlass
    cp -r ${src_cutlass_fbgemm_recursive}/* $out/third_party/cutlass
    chmod u+w $out/third_party/googletest
    cp -r ${src_googletest_fbgemm_recursive}/* $out/third_party/googletest
    chmod u+w $out/third_party/hipify_torch
    cp -r ${src_hipify_torch_recursive}/* $out/third_party/hipify_torch
  '';
  src_fbjni_recursive = src_fbjni;
  src_flatbuffers_recursive = src_flatbuffers;
  src_fmt_recursive = src_fmt;
  src_fmt_dynolog_recursive = src_fmt_dynolog;
  src_fmt_kineto_recursive = src_fmt_kineto;
  src_gemmlowp_recursive = src_gemmlowp;
  src_gflags_recursive = runCommand "gflags" { } ''
    cp -r ${src_gflags} $out
    chmod u+w $out/doc
    cp -r ${src_gflags_gflags_recursive}/* $out/doc
  '';
  src_gflags_gflags_recursive = src_gflags_gflags;
  src_glog_recursive = src_glog;
  src_gloo_recursive = src_gloo;
  src_googletest_recursive = src_googletest;
  src_googletest_dynolog_recursive = src_googletest_dynolog;
  src_googletest_fbgemm_recursive = src_googletest_fbgemm;
  src_googletest_kineto_recursive = src_googletest_kineto;
  src_googletest_opentelemetry-cpp_recursive = src_googletest_opentelemetry-cpp;
  src_googletest_protobuf_recursive = src_googletest_protobuf;
  src_googletest_tensorpipe_recursive = src_googletest_tensorpipe;
  src_hipify_torch_recursive = src_hipify_torch;
  src_ideep_recursive = runCommand "ideep" { } ''
    cp -r ${src_ideep} $out
    chmod u+w $out/mkl-dnn
    cp -r ${src_mkl-dnn_recursive}/* $out/mkl-dnn
  '';
  src_ittapi_recursive = src_ittapi;
  src_json_recursive = src_json;
  src_json_dynolog_recursive = src_json_dynolog;
  src_json_opentelemetry-cpp_recursive = src_json_opentelemetry-cpp;
  src_kineto_recursive = runCommand "kineto" { } ''
    cp -r ${src_kineto} $out
    chmod u+w $out/libkineto/third_party/dynolog
    cp -r ${src_dynolog_recursive}/* $out/libkineto/third_party/dynolog
    chmod u+w $out/libkineto/third_party/fmt
    cp -r ${src_fmt_kineto_recursive}/* $out/libkineto/third_party/fmt
    chmod u+w $out/libkineto/third_party/googletest
    cp -r ${src_googletest_kineto_recursive}/* $out/libkineto/third_party/googletest
  '';
  src_libnop_recursive = src_libnop;
  src_libuv_recursive = src_libuv;
  src_mimalloc_recursive = src_mimalloc;
  src_mkl-dnn_recursive = src_mkl-dnn;
  src_nccl_recursive = src_nccl;
  src_onnx_recursive = runCommand "onnx" { } ''
    cp -r ${src_onnx} $out
    chmod u+w $out/third_party/benchmark
    cp -r ${src_benchmark_onnx_recursive}/* $out/third_party/benchmark
    chmod u+w $out/third_party/pybind11
    cp -r ${src_pybind11_onnx_recursive}/* $out/third_party/pybind11
  '';
  src_opentelemetry-cpp_recursive = runCommand "opentelemetry-cpp" { } ''
    cp -r ${src_opentelemetry-cpp} $out
    chmod u+w $out/third_party/benchmark
    cp -r ${src_benchmark_opentelemetry-cpp_recursive}/* $out/third_party/benchmark
    chmod u+w $out/third_party/googletest
    cp -r ${src_googletest_opentelemetry-cpp_recursive}/* $out/third_party/googletest
    chmod u+w $out/third_party/ms-gsl
    cp -r ${src_GSL_recursive}/* $out/third_party/ms-gsl
    chmod u+w $out/third_party/nlohmann-json
    cp -r ${src_json_opentelemetry-cpp_recursive}/* $out/third_party/nlohmann-json
    chmod u+w $out/third_party/opentelemetry-proto
    cp -r ${src_opentelemetry-proto_recursive}/* $out/third_party/opentelemetry-proto
    chmod u+w $out/third_party/opentracing-cpp
    cp -r ${src_opentracing-cpp_recursive}/* $out/third_party/opentracing-cpp
    chmod u+w $out/third_party/prometheus-cpp
    cp -r ${src_prometheus-cpp_recursive}/* $out/third_party/prometheus-cpp
    chmod u+w $out/tools/vcpkg
    cp -r ${src_vcpkg_recursive}/* $out/tools/vcpkg
  '';
  src_opentelemetry-proto_recursive = src_opentelemetry-proto;
  src_opentracing-cpp_recursive = src_opentracing-cpp;
  src_pfs_recursive = src_pfs;
  src_pocketfft_recursive = src_pocketfft;
  src_prometheus-cpp_recursive = runCommand "prometheus-cpp" { } ''
    cp -r ${src_prometheus-cpp} $out
    chmod u+w $out/3rdparty/civetweb
    cp -r ${src_civetweb_recursive}/* $out/3rdparty/civetweb
    chmod u+w $out/3rdparty/googletest
    cp -r ${src_googletest_recursive}/* $out/3rdparty/googletest
  '';
  src_protobuf_recursive = runCommand "protobuf" { } ''
    cp -r ${src_protobuf} $out
    chmod u+w $out/third_party/benchmark
    cp -r ${src_benchmark_protobuf_recursive}/* $out/third_party/benchmark
    chmod u+w $out/third_party/googletest
    cp -r ${src_googletest_protobuf_recursive}/* $out/third_party/googletest
  '';
  src_psimd_recursive = src_psimd;
  src_pthreadpool_recursive = src_pthreadpool;
  src_pybind11_recursive = src_pybind11;
  src_pybind11_onnx_recursive = src_pybind11_onnx;
  src_pybind11_tensorpipe_recursive = runCommand "pybind11_tensorpipe" { } ''
    cp -r ${src_pybind11_tensorpipe} $out
    chmod u+w $out/tools/clang
    cp -r ${src_clang-cindex-python3_recursive}/* $out/tools/clang
  '';
  src_pytorch_recursive = runCommand "pytorch" { } ''
    cp -r ${src_pytorch} $out
    chmod u+w $out/android/libs/fbjni
    cp -r ${src_fbjni_recursive}/* $out/android/libs/fbjni
    chmod u+w $out/third_party/FP16
    cp -r ${src_FP16_recursive}/* $out/third_party/FP16
    chmod u+w $out/third_party/FXdiv
    cp -r ${src_FXdiv_recursive}/* $out/third_party/FXdiv
    chmod u+w $out/third_party/NNPACK
    cp -r ${src_NNPACK_recursive}/* $out/third_party/NNPACK
    chmod u+w $out/third_party/NVTX
    cp -r ${src_NVTX_recursive}/* $out/third_party/NVTX
    chmod u+w $out/third_party/VulkanMemoryAllocator
    cp -r ${src_VulkanMemoryAllocator_recursive}/* $out/third_party/VulkanMemoryAllocator
    chmod u+w $out/third_party/XNNPACK
    cp -r ${src_XNNPACK_recursive}/* $out/third_party/XNNPACK
    chmod u+w $out/third_party/benchmark
    cp -r ${src_benchmark_recursive}/* $out/third_party/benchmark
    chmod u+w $out/third_party/cpp-httplib
    cp -r ${src_cpp-httplib_recursive}/* $out/third_party/cpp-httplib
    chmod u+w $out/third_party/cpuinfo
    cp -r ${src_cpuinfo_recursive}/* $out/third_party/cpuinfo
    chmod u+w $out/third_party/cudnn_frontend
    cp -r ${src_cudnn-frontend_recursive}/* $out/third_party/cudnn_frontend
    chmod u+w $out/third_party/cutlass
    cp -r ${src_cutlass_recursive}/* $out/third_party/cutlass
    chmod u+w $out/third_party/eigen
    cp -r ${src_eigen_recursive}/* $out/third_party/eigen
    chmod u+w $out/third_party/fbgemm
    cp -r ${src_fbgemm_recursive}/* $out/third_party/fbgemm
    chmod u+w $out/third_party/flatbuffers
    cp -r ${src_flatbuffers_recursive}/* $out/third_party/flatbuffers
    chmod u+w $out/third_party/fmt
    cp -r ${src_fmt_recursive}/* $out/third_party/fmt
    chmod u+w $out/third_party/gemmlowp/gemmlowp
    cp -r ${src_gemmlowp_recursive}/* $out/third_party/gemmlowp/gemmlowp
    chmod u+w $out/third_party/gloo
    cp -r ${src_gloo_recursive}/* $out/third_party/gloo
    chmod u+w $out/third_party/googletest
    cp -r ${src_googletest_recursive}/* $out/third_party/googletest
    chmod u+w $out/third_party/ideep
    cp -r ${src_ideep_recursive}/* $out/third_party/ideep
    chmod u+w $out/third_party/ittapi
    cp -r ${src_ittapi_recursive}/* $out/third_party/ittapi
    chmod u+w $out/third_party/kineto
    cp -r ${src_kineto_recursive}/* $out/third_party/kineto
    chmod u+w $out/third_party/mimalloc
    cp -r ${src_mimalloc_recursive}/* $out/third_party/mimalloc
    chmod u+w $out/third_party/nccl/nccl
    cp -r ${src_nccl_recursive}/* $out/third_party/nccl/nccl
    chmod u+w $out/third_party/nlohmann
    cp -r ${src_json_recursive}/* $out/third_party/nlohmann
    chmod u+w $out/third_party/onnx
    cp -r ${src_onnx_recursive}/* $out/third_party/onnx
    chmod u+w $out/third_party/opentelemetry-cpp
    cp -r ${src_opentelemetry-cpp_recursive}/* $out/third_party/opentelemetry-cpp
    chmod u+w $out/third_party/pocketfft
    cp -r ${src_pocketfft_recursive}/* $out/third_party/pocketfft
    chmod u+w $out/third_party/protobuf
    cp -r ${src_protobuf_recursive}/* $out/third_party/protobuf
    chmod u+w $out/third_party/psimd
    cp -r ${src_psimd_recursive}/* $out/third_party/psimd
    chmod u+w $out/third_party/pthreadpool
    cp -r ${src_pthreadpool_recursive}/* $out/third_party/pthreadpool
    chmod u+w $out/third_party/pybind11
    cp -r ${src_pybind11_recursive}/* $out/third_party/pybind11
    chmod u+w $out/third_party/python-peachpy
    cp -r ${src_PeachPy_recursive}/* $out/third_party/python-peachpy
    chmod u+w $out/third_party/sleef
    cp -r ${src_sleef_recursive}/* $out/third_party/sleef
    chmod u+w $out/third_party/tensorpipe
    cp -r ${src_tensorpipe_recursive}/* $out/third_party/tensorpipe
  '';
  src_sleef_recursive = src_sleef;
  src_tensorpipe_recursive = runCommand "tensorpipe" { } ''
    cp -r ${src_tensorpipe} $out
    chmod u+w $out/third_party/googletest
    cp -r ${src_googletest_tensorpipe_recursive}/* $out/third_party/googletest
    chmod u+w $out/third_party/libnop
    cp -r ${src_libnop_recursive}/* $out/third_party/libnop
    chmod u+w $out/third_party/libuv
    cp -r ${src_libuv_recursive}/* $out/third_party/libuv
    chmod u+w $out/third_party/pybind11
    cp -r ${src_pybind11_tensorpipe_recursive}/* $out/third_party/pybind11
  '';
  src_vcpkg_recursive = src_vcpkg;
}).src_pytorch_recursive
# Update using: unroll-src [version]
