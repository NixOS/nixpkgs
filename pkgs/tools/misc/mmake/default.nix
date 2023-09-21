{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mmake";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "tj";
    repo = "mmake";
    rev = "v${version}";
    sha256 = "sha256-JPsVfLIl06PJ8Nsfu7ogwrttB1G93HTKbZFqUTSV9O8=";
  };

  vendorHash = "sha256-0z+sujzzBl/rtzXbhL4Os+jYfLUuO9PlXshUDxAH9DU=";

  ldflags = [ "-s" "-w" ];

  # Almost all tests require non-local networking, trying to resolve githubusercontent.com.
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/tj/mmake";
    description = "A small program  which wraps make to provide additional functionality";
    longDescription = ''
      Mmake is a small program  which wraps make to provide additional
      functionality,  such   as  user-friendly  help   output,  remote
      includes,  and   eventually  more.   It  otherwise  acts   as  a
      pass-through to standard make.
    '';
    license = licenses.mit;
    maintainers = [ maintainers.gabesoft ];
  };
}
