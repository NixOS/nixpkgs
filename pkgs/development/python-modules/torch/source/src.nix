{
  version,
  fetchFromGitLab,
  fetchFromGitHub,
  runCommand,
}:
assert version == "2.11.0";
rec {
  src_aiter = fetchFromGitHub {
    owner = "ROCm";
    repo = "aiter";
    rev = "9a469a608b2c10b7157df573a38d31e5bf4038b4";
    hash = "sha256-kaX3uAkgE99puYu+ODdKjvsN+LLl1Jt95vtd5Xh0Mg8=";
  };
  src_asmjit = fetchFromGitHub {
    owner = "asmjit";
    repo = "asmjit";
    rev = "a3199e8857792cd10b7589ff5d58343d2c9008ea";
    hash = "sha256-qb0lM1N1FIvoADNsZZdlg8HAheePv/LvSDvRhOAqZc0=";
  };
  src_benchmark = fetchFromGitHub {
    owner = "google";
    repo = "benchmark";
    rev = "299e5928955cc62af9968370293b916f5130916f";
    hash = "sha256-iPK3qLrZL2L08XW1a7SGl7GAt5InQ5nY+Dn8hBuxSOg=";
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
    rev = "d7ba35bbb649209c66e582d5a0244ba988a15159";
    hash = "sha256-eXb5f2jhtfxDORG+JniSy17kzB7A4vM0UnUQAfKTquU=";
  };
  src_clang-cindex-python3 = fetchFromGitHub {
    owner = "wjakob";
    repo = "clang-cindex-python3";
    rev = "6a00cbc4a9b8e68b71caf7f774b3f9c753ae84d5";
    hash = "sha256-IDUIuAvgCzWaHoTJUZrH15bqoVcP8bZk+Gs1Ae6/CpY=";
  };
  src_composable_kernel = fetchFromGitHub {
    owner = "ROCm";
    repo = "composable_kernel";
    rev = "fcc9372c009c8e0a23fece77b582da83b04a654f";
    hash = "sha256-Xwj48Ftwqlea5ZIP7q7cRh2U2tlHTd1cdW4TYf5J0Dg=";
  };
  src_composable_kernel_fbgemm_MSLK = fetchFromGitHub {
    owner = "ROCm";
    repo = "composable_kernel";
    rev = "7fe50dc3da2069d6645d9deb8c017a876472a977";
    hash = "sha256-OxA0ekcaRxAmBFlXkvS7XAX40kcWCwyytHWV6vROWjo=";
  };
  src_composable_kernel_flash-attention = fetchFromGitHub {
    owner = "ROCm";
    repo = "composable_kernel";
    rev = "13f6d635653bd5ffbfcac8577f1ef09590c23d78";
    hash = "sha256-nS1Apx4kLTIz7U2/X1BVQHiBwa5j59VboaibOhH9ADM=";
  };
  src_cpp-httplib = fetchFromGitHub {
    owner = "yhirose";
    repo = "cpp-httplib";
    rev = "bd95e67c234930cd6d6bb11309588c5462c63cec";
    hash = "sha256-5q77ersAJnPPpVChvntnqEly1/ek2KfX2iukTPUbKHc=";
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
    rev = "f858c30bcb16f8effd5ff46996f0514539e17abc";
    hash = "sha256-9eXqsdgGl4oZEC8uJgiyqrvD3HVyUuNcSkJ8VTmZBj8=";
  };
  src_cpuinfo_fbgemm = fetchFromGitHub {
    owner = "pytorch";
    repo = "cpuinfo";
    rev = "161a9ec374884f4b3e85725cb22e05f9458fdc93";
    hash = "sha256-uzo6QpNfzTcqOpDse14e2OoxNyKDU8jSx+/wPLxmpJg=";
  };
  src_cudnn-frontend = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cudnn-frontend";
    rev = "b8c0656e6f6c84fc194f4d57329b55d609eff596";
    hash = "sha256-G1WYxRCsg67umzOZ9W+JwXV6hfl5n2wtsH9KxVUccTU=";
  };
  src_cutlass = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cutlass";
    rev = "0d2b201e8c1c4a03efa6e9c468161916e2334725";
    hash = "sha256-2xgdS2P2tEI/4qcZv9qjCYHFbAcVayMdCDeJfIiQN4U=";
  };
  src_cutlass_fbgemm = fetchFromGitHub {
    owner = "jwfromm";
    repo = "cutlass";
    rev = "a54461186bc30c39bf89bc433f89198892ad9e5f";
    hash = "sha256-me+IKK79OJz4tCioc1GxJxp620KFL4yYk5r85XHj3zQ=";
  };
  src_cutlass_flash-attention = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cutlass";
    rev = "7127592069c2fe01b041e174ba4345ef9b279671";
    hash = "sha256-/fEfuriQbrjjLP+yRjeo88SgW3IurdlU+6rR9+w5woQ=";
  };
  src_cutlass_MSLK = fetchFromGitHub {
    owner = "jwfromm";
    repo = "cutlass";
    rev = "571edeb2d0ac872a8392fc49285b156b07884b4e";
    hash = "sha256-EnEtWPJqJBLGOk93HdUL45NFqIVG5qetJX6vnc7K6pE=";
  };
  src_DCGM = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "DCGM";
    rev = "ffde4e54bc7249a6039a5e6b45b395141e1217f9";
    hash = "sha256-jlnq25byEep7wRF3luOIGaiaYjqSVaTBx02N6gE/ox8=";
  };
  src_dynolog = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "dynolog";
    rev = "d2ffe0a4e3acace628db49974246b66fc3e85fb1";
    hash = "sha256-AebAZeDE9mXvg1XsgDm/4DIAMDIkbd+HGgcTmxV+HX0=";
  };
  src_fbgemm = fetchFromGitHub {
    owner = "pytorch";
    repo = "fbgemm";
    rev = "c246916f9e3804eacc3c95058e51cce02ae00fff";
    hash = "sha256-jNc9Z3fe4pUTP5FY3sV1WINoEEd8te6tTyjNsFWZFxY=";
  };
  src_fbjni = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "fbjni";
    rev = "7e1e1fe3858c63c251c637ae41a20de425dde96f";
    hash = "sha256-PsgUHtCE3dNR2QdUnRjrXb0ZKZNGwFkA8RWYkZEklEY=";
  };
  src_flash-attention = fetchFromGitHub {
    owner = "Dao-AILab";
    repo = "flash-attention";
    rev = "e2743ab5b3803bb672b16437ba98a3b1d4576c50";
    hash = "sha256-ft3jPiKZDHzZvkGPI34l8/Hq9Rf2f6UjDPKGU2IYz+E=";
  };
  src_flatbuffers = fetchFromGitHub {
    owner = "google";
    repo = "flatbuffers";
    rev = "a2cd1ea3b6d3fee220106b5fed3f7ce8da9eb757";
    hash = "sha256-6L6Eb+2xGXEqLYITWsNNPW4FTvfPFSmChK4hLusk5gU=";
  };
  src_fmt = fetchFromGitHub {
    owner = "fmtlib";
    repo = "fmt";
    rev = "407c905e45ad75fc29bf0f9bb7c5c2fd3475976f";
    hash = "sha256-ZmI1Dv0ZabPlxa02OpERI47jp7zFfjpeWCy1WyuPYZ0=";
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
    rev = "40626af88bd7df9a5fb80be7b25ac85b122d6c21";
    hash = "sha256-sAlU5L/olxQUYcv8euVYWTTB8TrVeQgXLHtXy8IMEnU=";
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
    owner = "pytorch";
    repo = "gloo";
    rev = "3135b0b41b67dde590eef0938a0bf3d6238df5f7";
    hash = "sha256-lCKZyH8p54UaSDGRTxM6ZMorc+japeJulv7FQn0GnHc=";
  };
  src_googletest = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "52eb8108c5bdec04579160ae17225d66034bd723";
    hash = "sha256-HIHMxAUR4bjmFLoltJeIAVSulVQ6kVuIT2Ku+lwAx/4=";
  };
  src_googletest_prometheus-cpp = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "e2239ee6043f73722e7aa812a459f54a28552929";
    hash = "sha256-SjlJxushfry13RGA7BCjYC9oZqV4z6x8dOiHfl/wpF0=";
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
    rev = "63b6a7b541fa7f08f8475ca7d74054db36ff2691";
    hash = "sha256-TH9fyprP21sRsxGs4VrahhFSIXDhnLvV09c+ZCE27u0=";
  };
  src_ideep = fetchFromGitHub {
    owner = "intel";
    repo = "ideep";
    rev = "8e7ddd65df95f13e41f0a40c820c5f35ae4a0ea3";
    hash = "sha256-AVSsugGYiQ4QOWMVaHj1hzlPTZmg65yrGMmrWytvUuM=";
  };
  src_ittapi = fetchFromGitHub {
    owner = "intel";
    repo = "ittapi";
    rev = "0c57540822deb5dae43bef6c1cc9b3be4772a033";
    hash = "sha256-v6efQEMW1r5fsjOIpJQQPoau6sina/iKxAY1cfEUZQc=";
  };
  src_json = fetchFromGitHub {
    owner = "nlohmann";
    repo = "json";
    rev = "55f93686c01528224f448c19128836e7df245f72";
    hash = "sha256-cECvDOLxgX7Q9R3IE86Hj9JJUxraDQvhoyPDF03B2CY=";
  };
  src_json_dynolog = fetchFromGitHub {
    owner = "nlohmann";
    repo = "json";
    rev = "4f8fba14066156b73f1189a2b8bd568bde5284c5";
    hash = "sha256-DTsZrdB9GcaNkx7ZKxcgCA3A9ShM5icSF0xyGguJNbk=";
  };
  src_json_fbgemm = fetchFromGitHub {
    owner = "nlohmann";
    repo = "json";
    rev = "9cca280a4d0ccf0c08f47a99aa71d1b0e52f8d03";
    hash = "sha256-7F0Jon+1oWL7uqet5i1IgHX0fUw/+z0QwEcA3zs5xHg=";
  };
  src_kineto = fetchFromGitHub {
    owner = "pytorch";
    repo = "kineto";
    rev = "7a731b6ae01cfc2b1fc75d83a91f84e682e43fd7";
    hash = "sha256-kKASzILEvFhXDWDqBiNh21VxhtdT506NYoEDVrtVcGU=";
  };
  src_kleidiai = fetchFromGitHub {
    owner = "ARM-software";
    repo = "kleidiai";
    rev = "d7770c89632329a9914ef1a90289917597639cbe";
    hash = "sha256-5/LkO8ihQCeA6nok68OrzurOcIgjFgXntO1C3By5HUw=";
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
    rev = "5152db2cbfeb5582e9c27c5ea1dba2cd9e10759b";
    hash = "sha256-ayTk3qkeeAjrGj5ab7wF7vpWI8XWS1EeKKUqzaD/LY0=";
  };
  src_mimalloc = fetchFromGitHub {
    owner = "microsoft";
    repo = "mimalloc";
    rev = "048d969a1c5ee2fb89c226298f41ea38445546ef";
    hash = "sha256-ZxIkzMIqwYZpiqbPAHDrO26xaiaF77Dlosbw43VkOpc=";
  };
  src_mkl-dnn = fetchFromGitHub {
    owner = "intel";
    repo = "mkl-dnn";
    rev = "f1d471933dc852f956fd05389f9313c7148783d5";
    hash = "sha256-/e57voLBNun/2koTF3sEb0Z/nDjCwq9NJVk7TaTSvMY=";
  };
  src_MSLK = fetchFromGitHub {
    owner = "meta-pytorch";
    repo = "MSLK";
    rev = "3d332d1c0c0ac7765852c97b3979c9ef913e037f";
    hash = "sha256-iuwAI8ko4yzifjoqKLxtz6UFOAOoWhsw4+3Unkiv6aE=";
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
    rev = "3ebbc93ded7285963bff932c678fa367eb393ba6";
    hash = "sha256-F1TD1lK0sE6UWMhelF1q147T5Jk3xFUHwsmKoE+WnXY=";
  };
  src_onnx = fetchFromGitHub {
    owner = "onnx";
    repo = "onnx";
    rev = "e709452ef2bbc1d113faf678c24e6d3467696e83";
    hash = "sha256-UhtF+CWuyv5/Pq/5agLL4Y95YNP63W2BraprhRqJOag=";
  };
  src_PeachPy = fetchFromGitHub {
    owner = "malfet";
    repo = "PeachPy";
    rev = "f45429b087dd7d5bc78bb40dc7cf06425c252d67";
    hash = "sha256-eyhfnOOZPtsJwjkF6ybv3F77fyjaV6wzgu+LxadZVw0=";
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
    rev = "0fa0ef591e38c2758e3184c6c23e497b9f732ffa";
    hash = "sha256-Fu786IHiU6Bl66gZ/UJmqOROjlya3viLyzOxwdZVi9c=";
  };
  src_prometheus-cpp = fetchFromGitHub {
    owner = "jupp0r";
    repo = "prometheus-cpp";
    rev = "b1234816facfdda29845c46696a02998a4af115a";
    hash = "sha256-Dj+adszXnWHOcZJ/QTOX214N86pjy71tLuPU6bHcMPg=";
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
    rev = "f5fbe867d2d26e4a0a9177a51f6e568868ad3dc8";
    hash = "sha256-ZiwNGsE1FOkhnWv/1ib1akhQ4FZvrXRCDnnBZoPp6r4=";
  };
  src_pybind11_onnx = fetchFromGitHub {
    owner = "pybind";
    repo = "pybind11";
    rev = "a2e59f0e7065404b44dfe92a28aca47ba1378dc4";
    hash = "sha256-SNLdtrOjaC3lGHN9MAqTf51U9EzNKQLyTMNPe0GcdrU=";
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
    rev = "v2.11.0";
    hash = "sha256-eA/pRQiibLJCKDUkMvmGq4suhrz37i0x0Lc/sH3Ag8E=";
  };
  src_sleef = fetchFromGitHub {
    owner = "shibatch";
    repo = "sleef";
    rev = "5a1d179df9cf652951b59010a2d2075372d67f68";
    hash = "sha256-bjT+F7/nyiB4f0T06/flbpIWFZbUxjf1TjWMe3112Ig=";
  };
  src_tensorpipe = fetchFromGitHub {
    owner = "pytorch";
    repo = "tensorpipe";
    rev = "2b4cd91092d335a697416b2a3cb398283246849d";
    hash = "sha256-ZidonG6q621rbdRrlW6ad7WdH0os81GNBBuPE5kQEsU=";
  };
  src_VulkanMemoryAllocator = fetchFromGitHub {
    owner = "GPUOpen-LibrariesAndSDKs";
    repo = "VulkanMemoryAllocator";
    rev = "1d8f600fd424278486eade7ed3e877c99f0846b1";
    hash = "sha256-TPEqV8uHbnyphLG0A+b2tgLDQ6K7a2dOuDHlaFPzTeE=";
  };
  src_XNNPACK = fetchFromGitHub {
    owner = "google";
    repo = "XNNPACK";
    rev = "51a0103656eff6fc9bfd39a4597923c4b542c883";
    hash = "sha256-nhowllqv/hBs7xHdTwbWtiKJ1mvAYsVIyIZ35ZGsmkg=";
  };
  src_aiter_recursive = runCommand "aiter" { } ''
    cp -r ${src_aiter} $out
    chmod u+w $out/3rdparty/composable_kernel
    cp -r ${src_composable_kernel_recursive}/* $out/3rdparty/composable_kernel
  '';
  src_asmjit_recursive = src_asmjit;
  src_benchmark_recursive = src_benchmark;
  src_benchmark_protobuf_recursive = src_benchmark_protobuf;
  src_civetweb_recursive = src_civetweb;
  src_clang-cindex-python3_recursive = src_clang-cindex-python3;
  src_composable_kernel_recursive = src_composable_kernel;
  src_composable_kernel_fbgemm_MSLK_recursive = src_composable_kernel_fbgemm_MSLK;
  src_composable_kernel_flash-attention_recursive = src_composable_kernel_flash-attention;
  src_cpp-httplib_recursive = src_cpp-httplib;
  src_cpr_recursive = src_cpr;
  src_cpuinfo_recursive = src_cpuinfo;
  src_cpuinfo_fbgemm_recursive = src_cpuinfo_fbgemm;
  src_cudnn-frontend_recursive = src_cudnn-frontend;
  src_cutlass_recursive = src_cutlass;
  src_cutlass_fbgemm_recursive = src_cutlass_fbgemm;
  src_cutlass_flash-attention_recursive = src_cutlass_flash-attention;
  src_cutlass_MSLK_recursive = src_cutlass_MSLK;
  src_DCGM_recursive = src_DCGM;
  src_dynolog_recursive = runCommand "dynolog" { } ''
    cp -r ${src_dynolog} $out
    chmod u+w $out/third_party/cpr
    cp -r ${src_cpr_recursive}/* $out/third_party/cpr
    chmod u+w $out/third_party/DCGM
    cp -r ${src_DCGM_recursive}/* $out/third_party/DCGM
    chmod u+w $out/third_party/fmt
    cp -r ${src_fmt_dynolog_recursive}/* $out/third_party/fmt
    chmod u+w $out/third_party/gflags
    cp -r ${src_gflags_recursive}/* $out/third_party/gflags
    chmod u+w $out/third_party/glog
    cp -r ${src_glog_recursive}/* $out/third_party/glog
    chmod u+w $out/third_party/googletest
    cp -r ${src_googletest_recursive}/* $out/third_party/googletest
    chmod u+w $out/third_party/json
    cp -r ${src_json_dynolog_recursive}/* $out/third_party/json
    chmod u+w $out/third_party/pfs
    cp -r ${src_pfs_recursive}/* $out/third_party/pfs
    chmod u+w $out/third_party/prometheus-cpp
    cp -r ${src_prometheus-cpp_recursive}/* $out/third_party/prometheus-cpp
  '';
  src_fbgemm_recursive = runCommand "fbgemm" { } ''
    cp -r ${src_fbgemm} $out
    chmod u+w $out/external/asmjit
    cp -r ${src_asmjit_recursive}/* $out/external/asmjit
    chmod u+w $out/external/composable_kernel
    cp -r ${src_composable_kernel_fbgemm_MSLK_recursive}/* $out/external/composable_kernel
    chmod u+w $out/external/cpuinfo
    cp -r ${src_cpuinfo_fbgemm_recursive}/* $out/external/cpuinfo
    chmod u+w $out/external/cutlass
    cp -r ${src_cutlass_fbgemm_recursive}/* $out/external/cutlass
    chmod u+w $out/external/googletest
    cp -r ${src_googletest_recursive}/* $out/external/googletest
    chmod u+w $out/external/hipify_torch
    cp -r ${src_hipify_torch_recursive}/* $out/external/hipify_torch
    chmod u+w $out/external/json
    cp -r ${src_json_fbgemm_recursive}/* $out/external/json
  '';
  src_fbjni_recursive = src_fbjni;
  src_flash-attention_recursive = runCommand "flash-attention" { } ''
    cp -r ${src_flash-attention} $out
    chmod u+w $out/csrc/composable_kernel
    cp -r ${src_composable_kernel_flash-attention_recursive}/* $out/csrc/composable_kernel
    chmod u+w $out/csrc/cutlass
    cp -r ${src_cutlass_flash-attention_recursive}/* $out/csrc/cutlass
  '';
  src_flatbuffers_recursive = src_flatbuffers;
  src_fmt_recursive = src_fmt;
  src_fmt_dynolog_recursive = src_fmt_dynolog;
  src_fmt_kineto_recursive = src_fmt_kineto;
  src_FP16_recursive = src_FP16;
  src_FXdiv_recursive = src_FXdiv;
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
  src_googletest_prometheus-cpp_recursive = src_googletest_prometheus-cpp;
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
  src_json_fbgemm_recursive = src_json_fbgemm;
  src_kineto_recursive = runCommand "kineto" { } ''
    cp -r ${src_kineto} $out
    chmod u+w $out/libkineto/third_party/dynolog
    cp -r ${src_dynolog_recursive}/* $out/libkineto/third_party/dynolog
    chmod u+w $out/libkineto/third_party/fmt
    cp -r ${src_fmt_kineto_recursive}/* $out/libkineto/third_party/fmt
    chmod u+w $out/libkineto/third_party/googletest
    cp -r ${src_googletest_recursive}/* $out/libkineto/third_party/googletest
  '';
  src_kleidiai_recursive = src_kleidiai;
  src_libnop_recursive = src_libnop;
  src_libuv_recursive = src_libuv;
  src_mimalloc_recursive = src_mimalloc;
  src_mkl-dnn_recursive = src_mkl-dnn;
  src_MSLK_recursive = runCommand "MSLK" { } ''
    cp -r ${src_MSLK} $out
    chmod u+w $out/external/composable_kernel
    cp -r ${src_composable_kernel_fbgemm_MSLK_recursive}/* $out/external/composable_kernel
    chmod u+w $out/external/cutlass
    cp -r ${src_cutlass_MSLK_recursive}/* $out/external/cutlass
    chmod u+w $out/external/googletest
    cp -r ${src_googletest_recursive}/* $out/external/googletest
    chmod u+w $out/external/hipify_torch
    cp -r ${src_hipify_torch_recursive}/* $out/external/hipify_torch
  '';
  src_NNPACK_recursive = src_NNPACK;
  src_NVTX_recursive = src_NVTX;
  src_onnx_recursive = runCommand "onnx" { } ''
    cp -r ${src_onnx} $out
    chmod u+w $out/third_party/pybind11
    cp -r ${src_pybind11_onnx_recursive}/* $out/third_party/pybind11
  '';
  src_PeachPy_recursive = src_PeachPy;
  src_pfs_recursive = src_pfs;
  src_pocketfft_recursive = src_pocketfft;
  src_prometheus-cpp_recursive = runCommand "prometheus-cpp" { } ''
    cp -r ${src_prometheus-cpp} $out
    chmod u+w $out/3rdparty/civetweb
    cp -r ${src_civetweb_recursive}/* $out/3rdparty/civetweb
    chmod u+w $out/3rdparty/googletest
    cp -r ${src_googletest_prometheus-cpp_recursive}/* $out/3rdparty/googletest
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
    chmod u+w $out/third_party/aiter
    cp -r ${src_aiter_recursive}/* $out/third_party/aiter
    chmod u+w $out/third_party/benchmark
    cp -r ${src_benchmark_recursive}/* $out/third_party/benchmark
    chmod u+w $out/third_party/composable_kernel
    cp -r ${src_composable_kernel_recursive}/* $out/third_party/composable_kernel
    chmod u+w $out/third_party/cpp-httplib
    cp -r ${src_cpp-httplib_recursive}/* $out/third_party/cpp-httplib
    chmod u+w $out/third_party/cpuinfo
    cp -r ${src_cpuinfo_recursive}/* $out/third_party/cpuinfo
    chmod u+w $out/third_party/cudnn_frontend
    cp -r ${src_cudnn-frontend_recursive}/* $out/third_party/cudnn_frontend
    chmod u+w $out/third_party/cutlass
    cp -r ${src_cutlass_recursive}/* $out/third_party/cutlass
    chmod u+w $out/third_party/fbgemm
    cp -r ${src_fbgemm_recursive}/* $out/third_party/fbgemm
    chmod u+w $out/third_party/flash-attention
    cp -r ${src_flash-attention_recursive}/* $out/third_party/flash-attention
    chmod u+w $out/third_party/flatbuffers
    cp -r ${src_flatbuffers_recursive}/* $out/third_party/flatbuffers
    chmod u+w $out/third_party/fmt
    cp -r ${src_fmt_recursive}/* $out/third_party/fmt
    chmod u+w $out/third_party/FP16
    cp -r ${src_FP16_recursive}/* $out/third_party/FP16
    chmod u+w $out/third_party/FXdiv
    cp -r ${src_FXdiv_recursive}/* $out/third_party/FXdiv
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
    chmod u+w $out/third_party/kleidiai
    cp -r ${src_kleidiai_recursive}/* $out/third_party/kleidiai
    chmod u+w $out/third_party/mimalloc
    cp -r ${src_mimalloc_recursive}/* $out/third_party/mimalloc
    chmod u+w $out/third_party/mslk
    cp -r ${src_MSLK_recursive}/* $out/third_party/mslk
    chmod u+w $out/third_party/nlohmann
    cp -r ${src_json_recursive}/* $out/third_party/nlohmann
    chmod u+w $out/third_party/NNPACK
    cp -r ${src_NNPACK_recursive}/* $out/third_party/NNPACK
    chmod u+w $out/third_party/NVTX
    cp -r ${src_NVTX_recursive}/* $out/third_party/NVTX
    chmod u+w $out/third_party/onnx
    cp -r ${src_onnx_recursive}/* $out/third_party/onnx
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
    chmod u+w $out/third_party/VulkanMemoryAllocator
    cp -r ${src_VulkanMemoryAllocator_recursive}/* $out/third_party/VulkanMemoryAllocator
    chmod u+w $out/third_party/XNNPACK
    cp -r ${src_XNNPACK_recursive}/* $out/third_party/XNNPACK
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
  src_VulkanMemoryAllocator_recursive = src_VulkanMemoryAllocator;
  src_XNNPACK_recursive = src_XNNPACK;
}
.src_pytorch_recursive
# Update using: unroll-src [version]
