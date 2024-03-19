{ stdenv, fetchFromGitHub, pkg-config, libGL, glfw, soil, lib }:

stdenv.mkDerivation {
  pname = "esshader";
  version = "unstable-2020-08-09";

  src = fetchFromGitHub {
    owner = "cmcsun";
    repo = "esshader";
    rev = "506eb02f3de52d3d1f4d81ac9ee145655216dee5";
    sha256 = "sha256-euxJw7CqOwi6Ndzalps37kDr5oOIL3tZICCfmxsujfk=";
  };

  postPatch = ''
    substituteInPlace config.mk \
      --replace "-lGLESv2" "-lGL -lGLESv2"
  '';

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    libGL glfw soil
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -a esshader $out/bin/
  '';

  meta = with lib; {
    description = "Offline ShaderToy-compatible GLSL shader viewer using OpenGL ES 2.0";
    homepage = "https://github.com/cmcsun/esshader";
    license = licenses.mit;
    maintainers = with maintainers; [ astro ];
    platforms = lib.platforms.unix;
    # never built on aarch64-darwin, x86_64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin;
    mainProgram = "esshader";
  };
}
