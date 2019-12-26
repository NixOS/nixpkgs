{ stdenv, fetchFromGitHub
, fetchpatch
, autoreconfHook
, python3Packages
, bashInteractive
}:

stdenv.mkDerivation rec {
  pname = "bash-completion";
  # TODO: Remove musl patch below upon next release!
  version = "2.9";

  src = fetchFromGitHub {
    owner = "scop";
    repo = "bash-completion";
    rev = version;
    sha256 = "1813r4jxfa2zgzm2ppjhrq62flfmxai8433pklxcrl4fp5wwx9yv";
  };

  nativeBuildInputs = [ autoreconfHook ];

  doCheck = !stdenv.isDarwin;
  checkInputs = [
    python3Packages.pexpect
    python3Packages.pytest
    bashInteractive
  ];

  patches = [
    ./0001-Revert-build-Do-cmake-pc-and-profile-variable-replac.patch
    # TODO: Remove when https://github.com/scop/bash-completion/commit/2cdac1b9f24df62a1fa80c1824ee8524c9b02393
    #       is availabe in a release in nixpkgs. see https://github.com/scop/bash-completion/issues/312.
    # Fixes a test failure with musl.
    (fetchpatch {
     url = "https://github.com/scop/bash-completion/commit/2cdac1b9f24df62a1fa80c1824ee8524c9b02393.patch";
     name = "bash-completion-musl-test_iconv-skip-option-completion-if-help-fails";
     sha256 = "1l53d62zf01k625nzw3vcrxky93h7bzdpchgk4argxalrn17ckvb";
    })
  ];

  # ignore ip_addresses because it tries to touch network
  # ignore test_ls because impure logic
  checkPhase = ''
    pytest . \
      --ignore=test/t/unit/test_unit_ip_addresses.py \
      --ignore=test/t/test_ls.py
  '';

  prePatch = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i -e 's/readlink -f/readlink/g' bash_completion completions/*
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/scop/bash-completion;
    description = "Programmable completion for the bash shell";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.peti ];
  };
}
