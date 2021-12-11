{ lib
, stdenv
, python27Packages
, callPackage
, fetchFromGitHub
, makeWrapper
, # re2c deps
  autoreconfHook
, # py-yajl deps
  git
, # oil deps
  readline
, cmark
, file
, glibcLocales
, withReadline ? true
, darwin
, which
, cmake
, python27Full
}:

let
  version = "0.9.3";
  # rev == present HEAD of release/0.9.3
  rev = "20d23eed7949548bc897ddcf7701f720c81f438e";
  src = fetchFromGitHub {
    owner = "oilshell";
    repo = "oil";
    inherit rev;
    hash = "sha256-wyjydQv7xHY2hNsG/msfHdztFLD40atXM3X2Ib6cl3Q=";
    fetchSubmodules = true;

    /*
      It's not critical to drop most of these; the primary target is
      the vendored fork of Python-2.7.13, which is ~ 55M and over 3200
      files, dozens of which get interpreter script patches in fixup.

      Note: -f is necessary to keep it from being a pain to update
      hash on rev updates. Command will fail w/o and not print hash.
    */
    # extraPostFetch = ''
    #   rm -rf benchmarks metrics py-yajl rfc gold web testdata services demo devtools cpp
    # '';
  };
  re2c = stdenv.mkDerivation rec {
    pname = "re2c";
    version = "1.0.3";
    sourceRoot = "${src.name}/re2c";
    src = fetchFromGitHub {
      owner = "skvadrik";
      repo = "re2c";
      rev = version;
      sha256 = "0grx7nl9fwcn880v5ssjljhcb9c5p2a6xpwil7zxpmv0rwnr3yqi";
    };
    nativeBuildInputs = [ autoreconfHook ];
    preCheck = ''
      patchShebangs run_tests.sh
    '';
  };
  patchSrc = fetchFromGitHub {
    owner = "abathur";
    repo = "nix-py-dev-oil";
    rev = "v0.8.12.1";
    hash = "sha256-7JVnosdcvmVFN3h6SIeeqcJFcyFkai//fFuzi7ThNMY=";
  };
in

  /*
    Upstream isn't interested in packaging this as a library
    (or accepting all of the patches we need to do so).
    This creates one without disturbing upstream too much.
  */
stdenv.mkDerivation {
  pname = "oil";
  inherit version src;

  # patch to support a python package, pass tests on macOS, etc.
  patches = [
    "${patchSrc}/0004-disable-internal-py-yajl-for-nix-built.patch"
    "${patchSrc}/0006-disable_failing_libc_tests.patch"
  ];

  # TODO substitue the naked python2 call instead of having python27 as a dependency
  # TODO fix pythonpath to include py-yajl
  buildInputs = [ readline cmark cmake python27Full ] ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Carbon ];

  nativeBuildInputs = [ re2c file makeWrapper ];

  configurePhase = ''
    build/dev.sh yajl-release
    build/prepare.sh configure
    build/prepare.sh build-python
    build/dev.sh all
  '';

  buildPhase = ''
    build/dev.sh yajl
    make _bin/oil.ovm-dbg -J$NIX_BUILD_CORES
    make _release/oil.tar -J$NIX_BUILD_CORES
  '';

  _NIX_SHELL_LIBCMARK = "${cmark}/lib/libcmark${stdenv.hostPlatform.extensions.sharedLibrary}";

  meta = {
    description = "A new unix shell";
    homepage = "https://www.oilshell.org/";
    license = with lib.licenses; [
      psfl # Includes a portion of the python interpreter and standard library
      asl20 # Licence for Oil itself
    ];
    maintainers = with lib.maintainers; [ lheckemann alva ];
    changelog = "https://www.oilshell.org/release/${version}/changelog.html";
  };
  passthru = {
    shellPath = "/bin/osh";
  };
}
# python27Packages.buildPythonPackage {
#   pname = "oil";
#   inherit version src;


#   propagatedBuildInputs = with python27Packages; [ six typing ];

#   doCheck = true;

#   preBuild = ''
#     devtools/release.sh quick-oil-tarball
#   '';

#   postPatch = ''
#     patchShebangs asdl build core doctools frontend native oil_lang
#   '';

#   /*
#     We did convince oil to upstream an env for specifying
#     this to support a shell.nix. Would need a patch if they
#     later drop this support. See:
#     https://github.com/oilshell/oil/blob/46900310c7e4a07a6223eb6c08e4f26460aad285/doctools/cmark.py#L30-L34
#   */

#   # See earlier note on glibcLocales TODO: verify needed?
#   LOCALE_ARCHIVE = lib.optionalString (stdenv.buildPlatform.libc == "glibc") "${glibcLocales}/lib/locale/locale-archive";

#   # not exhaustive; just a spot-check for now
#   pythonImportsCheck = [ "oil" "oil._devbuild" ];

# }
