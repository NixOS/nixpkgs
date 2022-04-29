{ stdenv, buildGoModule, fetchFromGitHub, lib
, enableStatic ? stdenv.hostPlatform.isStatic
}:

buildGoModule rec {
  pname = "gobetween";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "yyyar";
    repo = "gobetween";
    rev = version;
    sha256 = "0bxf89l53sqan9qq23rwawjkcanv9p61sw56zjqhyx78f0bh0zbc";
  };

  patches = [
    ./gomod.patch
  ];

  buildPhase = ''
    make -e build${lib.optionalString enableStatic "-static"}
  '';

  vendorSha256 = "1nkni9ikpc0wngh5v0qmlpn5s9v85lb2ih22f3h3lih7nc29yv87";

  installPhase = ''
    mkdir -p $out/bin
    cp bin/gobetween $out/bin
    cp -r share $out/share
    cp -r config $out/share
  '';

  meta = with lib; {
    description = "Modern & minimalistic load balancer for the Сloud era";
    homepage = "https://gobetween.io";
    license = licenses.mit;
    maintainers = with maintainers; [ tomberek ];
  };
}
