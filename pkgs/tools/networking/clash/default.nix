{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "clash";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Dreamacro";
    repo = pname;
    rev = "v${version}";
    sha256 = "0qyfv6h6m86m5bwayj0s1pjldnbagy63zc2ygzpnicihmd58khny";
  };

  goPackagePath = "github.com/Dreamacro/clash";
  vendorSha256 = "0ap6wsx23s4q730s6d5cgc4ginh8zj5sd32k0za49fh50v8k8zbh";

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
