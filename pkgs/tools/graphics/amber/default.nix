{ lib, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, python3
, vulkan-headers
, vulkan-loader
}:
let
  glslang = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = "3ee5f2f1d3316e228916788b300d786bb574d337";
    sha256 = "1l5h9d92mzd35pgs0wibqfg7vbl771lwnvdlcsyhf6999khn5dzv";
  };

  lodepng = fetchFromGitHub {
    owner = "lvandeve";
    repo = "lodepng";
    rev = "34628e89e80cd007179b25b0b2695e6af0f57fac";
    sha256 = "10yaf218xnmhv7rsq6dysqrps43r30cgrs1z63h47z40x43ikia0";
  };

  shaderc = fetchFromGitHub {
    owner = "google";
    repo = "shaderc";
    rev = "ba92b11e1fcaf4c38a64f84d643d6429175bf650";
    sha256 = "041hip43siy2sr7h6habk9sxdmd45ag4kqgi8jk0vm1b8pqzkhqn";
  };

  spirv-headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "3fdabd0da2932c276b25b9b4a988ba134eba1aa6";
    sha256 = "17h5cn4dyw8ixp1cpw8vf1z90m0fn1hhlvh0iycmknccbb1z34q7";
  };

  spirv-tools = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "fd3cabd8b5fc43ce83884ac06486c283b9902b4f";
    sha256 = "1h3smicw5gzpa17syb30085zccydzs4f41fl30bcmiipdn2xfpjr";
  };

in
stdenv.mkDerivation rec {
  pname = "amber";
  version = "unstable-2020-09-23";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "0eee2d45d053dfc566baa58442a9b1b708e4f2a7";
    sha256 = "1rrbvmn9hvhj7xj89yqvy9mx0vg1qapdm5fkca8mkd3516d9f5pw";
  };

  buildInputs = [
    vulkan-headers
    vulkan-loader
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ];

  # Tests are disabled so we do not have to pull in googletest and more dependencies
  cmakeFlags = [ "-DAMBER_SKIP_TESTS=ON" ];

  prePatch = ''
    cp -r ${glslang}/ third_party/glslang
    cp -r ${lodepng}/ third_party/lodepng
    cp -r ${shaderc}/ third_party/shaderc
    cp -r ${spirv-tools}/ third_party/spirv-tools
    cp -r ${spirv-headers}/ third_party/spirv-headers
    chmod u+w -R third_party

    substituteInPlace CMakeLists.txt \
      --replace "-Werror" ""
    substituteInPlace tools/update_build_version.py \
      --replace "not os.path.exists(directory)" "True"
  '';

  installPhase = ''
    install -Dm755 -t $out/bin amber image_diff
  '';

  meta = with lib; {
    description = "Multi-API shader test framework";
    homepage = "https://github.com/google/amber";
    license = licenses.asl20;
    maintainers = with maintainers; [ Flakebi ];
  };
}
