{ lib
, stdenv
, fetchFromGitHub
, testers
, libtree
, runCommand
, coreutils
, dieHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libtree";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "haampie";
    repo = "libtree";
    rev = "v${finalAttrs.version}";
    hash = "sha256-q3JtQ9AxoP0ma9K96cC3gf6QmQ1FbS7T7I59qhkwbMk=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  # Fails at https://github.com/haampie/libtree/blob/v3.1.1/tests/07_origin_is_relative_to_symlink_location_not_realpath/Makefile#L28
  doCheck = false;

  passthru.tests = {
    version = testers.testVersion {
      package = libtree;
      command = "libtree --version";
      version = finalAttrs.version;
    };
    checkCoreUtils = runCommand "${finalAttrs.pname}-ls-test" {
      nativeBuildInputs = [ finalAttrs.finalPackage dieHook ];
    } ''
      libtree ${coreutils}/bin/ls > $out || die "libtree failed to show dependencies."
      [ -s $out ]
    '';
  };

  meta = with lib; {
    description = "Tree ldd with an option to bundle dependencies into a single folder";
    homepage = "https://github.com/haampie/libtree";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ prusnak rardiol ];
  };
})
