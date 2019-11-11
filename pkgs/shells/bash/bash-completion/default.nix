{ stdenv, fetchFromGitHub
, autoreconfHook
, python3Packages
, bashInteractive
}:

stdenv.mkDerivation rec {
  pname = "bash-completion";
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
