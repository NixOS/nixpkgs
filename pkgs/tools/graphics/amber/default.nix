{ lib, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, cctools
, python3
, vulkan-headers
, vulkan-loader
}:
let
  glslang = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = "81cc10a498b25a90147cccd6e8939493c1e9e20e";
    hash = "sha256-jTOxZ1nU7kvtdWjPzyIp/5ZeKw3JtYyqhlFeIE7CyX8=";
  };

  lodepng = fetchFromGitHub {
    owner = "lvandeve";
    repo = "lodepng";
    rev = "5601b8272a6850b7c5d693dd0c0e16da50be8d8d";
    hash = "sha256-dD8QoyOoGov6VENFNTXWRmen4nYYleoZ8+4TpICNSpo=";
  };

  shaderc = fetchFromGitHub {
    owner = "google";
    repo = "shaderc";
    rev = "e72186b66bb90ed06aaf15cbdc9a053581a0616b";
    hash = "sha256-hd1IGsWksgAfB8Mq5yZOzSyNGxXsCJxb350pD/Gcskk=";
  };

  spirv-headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "b42ba6d92faf6b4938e6f22ddd186dbdacc98d78";
    hash = "sha256-ks9JCj5rj+Xu++7z5RiHDkU3/sFXhcScw8dATfB/ot0=";
  };

  spirv-tools = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "a73e724359a274d7cf4f4248eba5be1e7764fbfd";
    hash = "sha256-vooJHtgVRlBNkQG4hulYOxIgHH4GMhXw7N4OEbkKJvU=";
  };

in
stdenv.mkDerivation rec {
  pname = "amber";
  version = "unstable-2022-04-21";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "8b145a6c89dcdb4ec28173339dd176fb7b6f43ed";
    hash = "sha256-+xFYlUs13khT6r475eJJ+XS875h2sb+YbJ8ZN4MOSAA=";
  };

  buildInputs = [
    vulkan-headers
    vulkan-loader
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ] ++ lib.optionals stdenv.isDarwin [
    cctools
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
