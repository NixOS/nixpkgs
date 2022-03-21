{ lib, buildGoModule, fetchFromGitHub, fetchpatch }:

buildGoModule rec {
  pname = "gron";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "tomnomnom";
    repo = "gron";
    rev = "v${version}";
    sha256 = "0qmzawkhg0qn9kxxrssbdjni2khvamhrcklv3yxc0ljmh77mh61m";
  };

  patches = [
    (fetchpatch {
      name = "fix-inconsistent-vendoring.patch";
      url = "https://github.com/tomnomnom/gron/pull/85/commits/d549a6cb68ed0e0ec7cc81d8275353acfe218725.patch";
      sha256 = "1461v4f7w6q75l3988br0g1ynfhzsh34z38pd2w8fp57vrgkcfi5";
    })
  ];

  vendorSha256 = "sha256-Evn5R/LzripRgG0zOVP/DJrtjwNRwgKapsRdtZaZhlU=";

  meta = with lib; {
    description = "Make JSON greppable!";
    longDescription = ''
      gron transforms JSON into discrete assignments to make it easier to grep
      for what you want and see the absolute 'path' to it. It eases the
      exploration of APIs that return large blobs of JSON but have terrible
      documentation.
    '';
    homepage = "https://github.com/tomnomnom/gron";
    license = licenses.mit;
    maintainers = with maintainers; [ fgaz SuperSandro2000 ];
    platforms = platforms.unix;
  };
}
