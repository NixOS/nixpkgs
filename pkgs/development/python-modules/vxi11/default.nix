{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  fetchpatch2,
}:

buildPythonPackage rec {
  pname = "python-vxi11";
  version = "0.9";

  # no tests in PyPI tarball
  src = fetchFromGitHub {
    owner = "python-ivi";
    repo = pname;
    rev = "v${version}";
    sha256 = "1xv7chp7rm0vrvbz6q57fpwhlgjz461h08q9zgmkcl2l0w96hmsn";
  };

  patches = [
    # set of patches from python-ivi/python-vxi11#47

    # Fix deprecation warning
    (fetchpatch2 {
      url = "https://github.com/python-ivi/python-vxi11/commit/00722b1b8810ac38bfb47e8c49437055b600dfff.patch?full_index=1";
      hash = "sha256-fZDhg578UY/Q/2li1EmL5WTPx1OUfyebzvvBVK/IyDU=";
    })

    # Removes nose dependency
    (fetchpatch2 {
      url = "https://github.com/python-ivi/python-vxi11/commit/a8ad324d645d6f7215f207f2cc2988dc49859698.patch?full_index=1";
      hash = "sha256-nkH6ww4jBypEmZeatEb8fpFTB7x/AMppeEmuH9a4v6I=";
    })
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "VXI-11 driver for controlling instruments over Ethernet";
    mainProgram = "vxi11-cli";
    homepage = "https://github.com/python-ivi/python-vxi11";
    license = licenses.mit;
    maintainers = with maintainers; [ bgamari ];
  };
}
