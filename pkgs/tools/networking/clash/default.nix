{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "clash";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "Dreamacro";
    repo = pname;
    rev = "v${version}";
    sha256 = "150zpjchldm1632z6gkydgqhx2a612lpwf5lqngd2if99nas54kk";
  };

  goPackagePath = "github.com/Dreamacro/clash";
  modSha256 = "02bki2iq99lc9iq1mjf9rbxwspalrj7hjlk1h384w3d4s4x4fyxy";

  buildFlagsArray = [
    "-ldflags="
    "-X ${goPackagePath}/constant.Version=${version}"
  ];

  meta = with stdenv.lib; {
    description = "A rule-based tunnel in Go";
    homepage = "https://github.com/Dreamacro/clash";
    license = licenses.gpl3;
    maintainers = with maintainers; [ contrun filalex77 ];
    platforms = platforms.all;
  };
}
